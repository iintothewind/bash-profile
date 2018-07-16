#!/usr/bin/env bash

# local proxy settings
function setLocalProxy() {
  export http_proxy=http://localhost:8123
  export https_proxy=http://localhost:8123
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxy Wi-Fi localhost 8123
    sudo networksetup -setsecurewebproxy Wi-Fi localhost 8123
    sudo networksetup -setwebproxy 'Thunderbolt Ethernet' localhost 8123
    sudo networksetup -setsecurewebproxy 'Thunderbolt Ethernet' localhost 8123
    sudo networksetup -setdnsservers Wi-Fi Empty
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
  return 0
}

# Corp Proxy settings
function setCorpProxy {
  export http_proxy=http://sjd-itcorppx.paypalcorp.com:3128
  export https_proxy=http://sjd-itcorppx.paypalcorp.com:3128
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxy Wi-Fi sjd-itcorppx.paypalcorp.com 3128
    sudo networksetup -setsecurewebproxy Wi-Fi sjd-itcorppx.paypalcorp.com 3128
    sudo networksetup -setdnsservers Wi-Fi Empty
    #sudo networksetup -setautoproxystate 'Thunderbolt Ethernet' off
    #sudo networksetup -setwebproxy 'Thunderbolt Ethernet' sjd-itcorppx.paypalcorp.com 3128
    #sudo networksetup -setsecurewebproxy 'Thunderbolt Ethernet' sjd-itcorppx.paypalcorp.com 3128
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
  return 0
}

function setCorpPac {
  export http_proxy=http://proxypacfile.paypalcorp.com/proxy.pac
  export https_proxy=http://proxypacfile.paypalcorp.com/proxy.pac

  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxyurl Wi-Fi "http://proxypacfile.paypalcorp.com/proxy.pac"
    sudo networksetup -setwebproxystate Wi-Fi off
    sudo networksetup -setsecurewebproxystate Wi-Fi off
    sudo networksetup -setdnsservers Wi-Fi Empty
    #sudo networksetup -setautoproxyurl 'Thunderbolt Ethernet' "http://proxypacfile.paypalcorp.com/proxy.pac"
    #sudo networksetup -setwebproxystate 'Thunderbolt Ethernet' off
    #sudo networksetup -setsecurewebproxystate 'Thunderbolt Ethernet' off
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
  return 0
}

# Shadowsocks Proxy settings
function setShadowSocksProxy {
  export http_proxy=http://192.168.0.161:8123
  export https_proxy=http://192.168.0.161:8123
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxy Wi-Fi 192.168.0.161 8123
    sudo networksetup -setsecurewebproxy Wi-Fi 192.168.0.161 8123
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
  return 0
}

function removeProxy {
  unset http_proxy
  unset https_proxy
  if [[ "$JAVA_OPTS" == *http* ]]; then
    unset JAVA_OPTS
  fi
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxystate Wi-Fi off
    sudo networksetup -setsecurewebproxystate Wi-Fi off
    #sudo networksetup -setwebproxystate 'Thunderbolt Ethernet' off
    #sudo networksetup -setautoproxystate 'Thunderbolt Ethernet' off
    #sudo networksetup -setsecurewebproxystate 'Thunderbolt Ethernet' off
  fi
  return 0
}

function getProxyStatus {
  echo "http_proxy=$http_proxy"
  echo "https_proxy=$https_proxy"
  if type networksetup > /dev/null 2>&1; then
    echo "networksetup -getwebproxy Wi-Fi"
    networksetup -getwebproxy Wi-Fi
    echo "networksetup -getsecurewebproxy Wi-Fi"
    networksetup -getsecurewebproxy Wi-Fi
  fi
}

if [[ $(uname) == Linux ]]; then
  alias mtproxy=setLocalProxy
  alias rmproxy=removeProxy
  alias pxys=getProxyStatus
  if type netstat > /dev/null 2>&1 && [[ $(netstat -tln|grep 1080) == tcp*0.0.0.0*1080*LISTEN* ]]; then 
    export http_proxy=http://localhost:8123
    export https_proxy=http://localhost:8123
  fi

  #if [[ $(nmap 192.168.0.161 -p 1080) == *open* ]]; then
  #  export http_proxy=http://192.168.0.161:8123
  #  export https_proxy=http://192.168.0.161:8123
  #fi
fi

if [[ $(uname) == Darwin ]]; then
  alias mtproxy=setCorpProxy
  alias mtpac=setCorpPac
  alias rmproxy=removeProxy
  alias pxys=getProxyStatus
  if [[ $(ipconfig getifaddr en0) == 10.225* ]]; then 
    export http_proxy=http://sjd-itcorppx.paypalcorp.com:3128
    export https_proxy=http://sjd-itcorppx.paypalcorp.com:3128
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
fi

export no_proxy="localhost,127.0.0.1,192.168.0.*"
