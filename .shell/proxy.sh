#!/usr/bin/env bash

function setProxy() {
  if [ ! -n "$1" ] || [ ! -n "$2" ]; then
    echo "proxy host and port are required"
  else
    if type networksetup > /dev/null 2>&1; then
      export http_proxy=http://"$1":"$2"
      export https_proxy=http://"$1":"$2"
      networksetup -listallnetworkservices | tail -n +2 | while read network_service; do  
        sudo networksetup -setautoproxystate "$network_service" off
        sudo networksetup -setwebproxy "$network_service" "$1"  "$2"
        sudo networksetup -setsecurewebproxy "$network_service" "$1"  "$2"
      done
    fi
  fi
  return 0
}

function setPac() {
  if [[ "$1" != http*pac ]]; then
    echo "pac file is required"
  else
    if type networksetup > /dev/null 2>&1; then
      networksetup -listallnetworkservices | tail -n +2 | while read network_service; do  
        sudo networksetup -setautoproxyurl "$network_service" "$1"
        sudo networksetup -setwebproxystate "$network_service" off
        sudo networksetup -setsecurewebproxystate "$network_service" off
      done
    fi
  fi
  return 0
}

function setJavaProxy() {
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
}

function rmProxy {
  unset http_proxy
  unset https_proxy
  if [[ "$JAVA_OPTS" == *http* ]]; then
    unset JAVA_OPTS
  fi
  if type networksetup > /dev/null 2>&1; then
    networksetup -listallnetworkservices | tail -n +2 | while read network_service; do  
      sudo networksetup -setautoproxystate "$network_service" off
      sudo networksetup -setwebproxystate "$network_service" off
      sudo networksetup -setsecurewebproxystate "$network_service" off
    done
  fi
  return 0
}

function pxys {
  echo "http_proxy=$http_proxy"
  echo "https_proxy=$https_proxy"
  if type networksetup > /dev/null 2>&1; then
    networksetup -listallnetworkservices | tail -n +2 | while read network_service; do  
      echo "$network_service http proxy: "
      networksetup -getwebproxy "$network_service"
      echo "$network_service https proxy: "
      networksetup -getsecurewebproxy "$network_service"
      echo ""
    done
  fi
}

# local proxy settings
function setLocalProxy() {
  setProxy localhost 8123
}

# Corp Proxy settings
function setCorpProxy {
  setProxy "sjd-itcorppx.paypalcorp.com" 3128
}

function setCorpPac {
  setPac "http://proxypacfile.paypalcorp.com/proxy.pac"
  return 0
}

export no_proxy="localhost,127.0.0.1,192.168.0.*"
