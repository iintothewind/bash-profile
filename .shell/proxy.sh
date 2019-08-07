#!/usr/bin/env bash

function shellProxy() {
  if [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "proxy host and port are required"
  else
    if [ "$3" != "" ] && [ "$4" != "" ]; then
      export http_proxy=http://$3:$4@$1:$2
      export https_proxy=http://$3:$4@$1:$2
    else
      export http_proxy=http://$1:$2
      export https_proxy=http://$1:$2
    fi
  fi
  return 0
}

function sysProxy() {
  local host=${1-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f2 | cut -d':' -f1)}
  local port=${2-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f2 | cut -d':' -f2)}
  if [[ $(uname) == Darwin ]] && test "$host" && test "$port"; then
    networksetup -listallnetworkservices | tail -n +2 | while read network_service; do
      if [[ $http_proxy == *@* ]]; then
        local usr=${3-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f1 | cut -d':' -f1)}
        local pwd=${4-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f1 | cut -d':' -f2)}
        # networksetup reports error when usr and pwd are used
        #sudo networksetup -setautoproxystate "$network_service" off
        #sudo networksetup -setwebproxy "$network_service" "$host"  "$port" on "$usr" "$pwd"
        #sudo networksetup -setsecurewebproxy "$network_service" "$host"  "$port" on "$usr" "pwd"
        sudo networksetup -setautoproxystate "$network_service" off
        sudo networksetup -setwebproxy "$network_service" "$host"  "$port"
        sudo networksetup -setsecurewebproxy "$network_service" "$host"  "$port"
      else
        sudo networksetup -setautoproxystate "$network_service" off
        sudo networksetup -setwebproxy "$network_service" "$host"  "$port"
        sudo networksetup -setsecurewebproxy "$network_service" "$host"  "$port"
      fi
    done
  else
    echo "mac only, proxy host and port are required"
  fi
  return 0
}

function javaProxy() {
  local host=${1-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f2 | cut -d':' -f1)}
  local port=${2-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f2 | cut -d':' -f2)}
  if test "$host" && test "$port"; then
    if [[ $http_proxy == *@* ]]; then
      local usr=${3-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f1 | cut -d':' -f1)}
      local pwd=${4-$(echo $http_proxy | cut -d'/' -f3 | cut -d'@' -f1 | cut -d':' -f2)}
      export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttp.proxyUser=$usr -Dhttp.proxyPassword=$pwd -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port -Dhttps.proxyUser=$usr -Dhttps.proxyPassword=$pwd"
    else
      export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
    fi
  else
    echo "proxy host and port are required"
  fi
  return 0
}

function pacProxy() {
  if [[ $(uname) == Darwin ]] && [[ "$1" == http*pac ]]; then
    networksetup -listallnetworkservices | tail -n +2 | while read network_service; do
      sudo networksetup -setautoproxyurl "$network_service" "$1"
      sudo networksetup -setwebproxystate "$network_service" off
      sudo networksetup -setsecurewebproxystate "$network_service" off
    done
  else
    echo "pac file is required"
  fi
  return 0
}


function rmProxy {
  unset http_proxy
  unset https_proxy
  if [[ "$JAVA_OPTS" == *proxy* ]]; then
    unset JAVA_OPTS
  fi
  if [[ $(uname) == Darwin ]]; then
    networksetup -listallnetworkservices | tail -n +2 | while read network_service; do
      if [[ $(networksetup -getwebproxy "$network_service") == *"Enabled: Yes"* ]]; then
        sudo networksetup -setwebproxystate "$network_service" off
        sudo networksetup -setsecurewebproxystate "$network_service" off
      fi

      if [[ $(networksetup -getautoproxyurl "$network_service") != ""  ]]; then
        sudo networksetup -setautoproxystate "$network_service" off
      fi
    done
  fi
  return 0
}

function pxys {
  echo "http_proxy=$http_proxy"
  echo "https_proxy=$https_proxy"
  if [[ "$JAVA_OPTS" == *proxy* ]]; then
    echo "JAVA_OPTS=$JAVA_OPTS"
  fi
  if [[ $(uname) == Darwin ]]; then
    networksetup -listallnetworkservices | tail -n +2 | while read network_service; do
      echo "$network_service http proxy: "
      networksetup -getwebproxy "$network_service"
      echo "$network_service https proxy: "
      networksetup -getsecurewebproxy "$network_service"
      echo "$network_service https auto proxy url: "
      networksetup -getautoproxyurl "$network_service"
      echo ""
    done
  fi
}

function localProxy() {
  shellProxy localhost 18123
}

function corpProxy {
  shellProxy "proxy.prd.plb.paypalcorp.com" 8080
}

function corpPac {
  pacProxy "http://proxypacfile.paypalcorp.com/proxy.pac"
}

export no_proxy="localhost,127.0.0.1,192.168.0.*,.local,10.*"
