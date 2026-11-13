#!/usr/bin/env bash
# os/darwin/proxy.sh: switch HTTP proxies for the shell, the JVM (JAVA_OPTS) and macOS network services.
# Loaded by init.sh in every shell when $OSTYPE is darwin*, after functions.sh; uses cf_trim from cf.sh.
# Contract:
#   - definitions only: nothing runs at load time (no_proxy/NO_PROXY are exported by env.sh)
#   - errors go to stderr with return 1
#   - no OS check in here: being in this directory is the check

# Parse http_proxy-style URL into host/port/user/pass.
# Sets: _proxy_host _proxy_port _proxy_user _proxy_pass
# Usage: proxy_parse [url]   (default: $http_proxy or $HTTP_PROXY)
function proxy_parse() {
  local url="${1:-${http_proxy:-$HTTP_PROXY}}"
  _proxy_host=; _proxy_port=; _proxy_user=; _proxy_pass=

  [[ -z "$url" ]] && return 1

  # strip scheme
  local rest="${url#*://}"
  if [[ "$rest" == *"@"* ]]; then
    local cred="${rest%%@*}"
    rest="${rest#*@}"
    _proxy_user="${cred%%:*}"
    _proxy_pass="${cred#*:}"
    [[ "$_proxy_pass" == "$_proxy_user" ]] && _proxy_pass=
  fi
  # drop path/query
  rest="${rest%%/*}"
  _proxy_host="${rest%%:*}"
  _proxy_port="${rest#*:}"
  [[ "$_proxy_port" == "$_proxy_host" ]] && _proxy_port=

  [[ -n "$_proxy_host" && -n "$_proxy_port" ]]
}

function shellProxy() {
  local host=$1 port=$2 user=$3 pass=$4
  if [[ -z "$host" || -z "$port" ]]; then
    echo "proxy host and port are required" >&2
    return 1
  fi

  local url
  if [[ -n "$user" && -n "$pass" ]]; then
    url="http://${user}:${pass}@${host}:${port}"
  else
    url="http://${host}:${port}"
  fi

  export http_proxy="$url"
  export https_proxy="$url"
  export HTTP_PROXY="$url"
  export HTTPS_PROXY="$url"
  return 0
}

function sysProxy() {
  local host=$1 port=$2
  if [[ -z "$host" || -z "$port" ]]; then
    proxy_parse || {
      echo "proxy host and port are required" >&2
      return 1
    }
    host=$_proxy_host
    port=$_proxy_port
  fi

  local network_service rc=0
  while IFS= read -r network_service; do
    sudo networksetup -setautoproxystate "$network_service" off || rc=$?
    sudo networksetup -setwebproxy "$network_service" "$host" "$port" || rc=$?
    sudo networksetup -setsecurewebproxy "$network_service" "$host" "$port" || rc=$?
  done < <(networksetup -listallnetworkservices | tail -n +2)

  return "$rc"
}

# Print $JAVA_OPTS without the -Dhttp(s).proxy* flags, trimmed.
function _proxy_java_opts_without_proxy() {
  cf_trim "$(printf '%s\n' "${JAVA_OPTS:-}" | sed -E 's/ *-Dhttps?\.proxy(Host|Port|User|Password)=[^ ]*//g')"
}

function javaProxy() {
  local host=$1 port=$2 user=$3 pass=$4
  if [[ -z "$host" || -z "$port" ]]; then
    proxy_parse || {
      echo "proxy host and port are required" >&2
      return 1
    }
    host=$_proxy_host
    port=$_proxy_port
    user=${user:-$_proxy_user}
    pass=${pass:-$_proxy_pass}
  fi

  local opts
  opts=$(_proxy_java_opts_without_proxy)

  local proxy_opts="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port} -Dhttps.proxyHost=${host} -Dhttps.proxyPort=${port}"
  if [[ -n "$user" && -n "$pass" ]]; then
    proxy_opts+=" -Dhttp.proxyUser=${user} -Dhttp.proxyPassword=${pass} -Dhttps.proxyUser=${user} -Dhttps.proxyPassword=${pass}"
  fi

  export JAVA_OPTS="${opts:+$opts }$proxy_opts"
  return 0
}

function pacProxy() {
  if [[ ! "$1" =~ ^https?://.+\.pac([?#].*)?$ ]]; then
    echo "pac url is required (http/https .../*.pac)" >&2
    return 1
  fi

  local network_service rc=0
  while IFS= read -r network_service; do
    sudo networksetup -setautoproxyurl "$network_service" "$1" || rc=$?
    sudo networksetup -setwebproxystate "$network_service" off || rc=$?
    sudo networksetup -setsecurewebproxystate "$network_service" off || rc=$?
  done < <(networksetup -listallnetworkservices | tail -n +2)

  return "$rc"
}

function rmProxy() {
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY all_proxy

  if [[ -n "${JAVA_OPTS:-}" ]]; then
    local opts
    opts=$(_proxy_java_opts_without_proxy)
    if [[ -n "$opts" ]]; then
      export JAVA_OPTS="$opts"
    else
      unset JAVA_OPTS
    fi
  fi

  local network_service
  while IFS= read -r network_service; do
    if [[ $(networksetup -getwebproxy "$network_service") == *"Enabled: Yes"* ]]; then
      sudo networksetup -setwebproxystate "$network_service" off
      sudo networksetup -setsecurewebproxystate "$network_service" off
    fi
    if [[ -n $(networksetup -getautoproxyurl "$network_service" | awk '/URL:/{print $2}') ]]; then
      sudo networksetup -setautoproxystate "$network_service" off
    fi
  done < <(networksetup -listallnetworkservices | tail -n +2)
  return 0
}

function pxys() {
  echo "http_proxy=${http_proxy:-}"
  echo "https_proxy=${https_proxy:-}"
  echo "HTTP_PROXY=${HTTP_PROXY:-}"
  echo "HTTPS_PROXY=${HTTPS_PROXY:-}"
  if [[ "${JAVA_OPTS:-}" == *proxy* ]]; then
    echo "JAVA_OPTS=$JAVA_OPTS"
  fi
  local network_service
  while IFS= read -r network_service; do
    echo "$network_service http proxy:"
    networksetup -getwebproxy "$network_service"
    echo "$network_service https proxy:"
    networksetup -getsecurewebproxy "$network_service"
    echo "$network_service auto proxy url:"
    networksetup -getautoproxyurl "$network_service"
    echo ""
  done < <(networksetup -listallnetworkservices | tail -n +2)
}

function localProxy() {
  shellProxy localhost 18123
}
