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

# GE Proxy settings
function setGeProxy {
  export http_proxy=http://3.20.128.6:88
  export https_proxy=http://3.20.128.6:88
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxy Wi-Fi 3.20.128.6 88
    sudo networksetup -setsecurewebproxy Wi-Fi 3.20.128.6 88
    sudo networksetup -setautoproxystate 'Thunderbolt Ethernet' off
    sudo networksetup -setwebproxy 'Thunderbolt Ethernet' 3.20.128.6 88
    sudo networksetup -setsecurewebproxy 'Thunderbolt Ethernet' 3.20.128.6 88
    sudo networksetup -setdnsservers Wi-Fi Empty
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
  return 0
}

function setGePac {
  export http_proxy=http://PITC-Zscaler-China-Shanghai-IDC-Z1.proxy.corporate.ge.com:80
  export https_proxy=http://PITC-Zscaler-China-Shanghai-IDC-Z1.proxy.corporate.ge.com:80

  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxyurl Wi-Fi "https://cloudproxy.setpac.ge.com/pac.pac"
    sudo networksetup -setautoproxyurl 'Thunderbolt Ethernet' "https://cloudproxy.setpac.ge.com/pac.pac"
    sudo networksetup -setwebproxystate Wi-Fi off
    sudo networksetup -setsecurewebproxystate Wi-Fi off
    sudo networksetup -setwebproxystate 'Thunderbolt Ethernet' off
    sudo networksetup -setsecurewebproxystate 'Thunderbolt Ethernet' off
    sudo networksetup -setdnsservers Wi-Fi Empty
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
    sudo networksetup -setautoproxystate 'Thunderbolt Ethernet' off
    sudo networksetup -setwebproxystate Wi-Fi off
    sudo networksetup -setwebproxystate 'Thunderbolt Ethernet' off
    sudo networksetup -setsecurewebproxystate Wi-Fi off
    sudo networksetup -setsecurewebproxystate 'Thunderbolt Ethernet' off
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
  alias mtscproxy=setShadowSocksProxy
  alias rmproxy=removeProxy
  alias pxys=getProxyStatus
  if [[ $(netstat -tln|grep 1080) == tcp*0.0.0.0*1080*LISTEN* ]]; then 
    export http_proxy=http://localhost:8123
    export https_proxy=http://localhost:8123
  fi

  #if [[ $(nmap 192.168.0.161 -p 1080) == *open* ]]; then
  #  export http_proxy=http://192.168.0.161:8123
  #  export https_proxy=http://192.168.0.161:8123
  #fi
fi

if [[ $(uname) == Darwin ]]; then
  alias mtlocalproxy=setLocalProxy
  alias mtgeproxy=setGeProxy
  alias mtgepac=setGePac
  alias mtscproxy=setShadowSocksProxy
  alias rmproxy=removeProxy
  alias pxys=getProxyStatus
  if [[ $(ipconfig getifaddr en0) == 10.189* ]]; then 
    export http_proxy=http://3.20.128.6:88
    export https_proxy=http://3.20.128.6:88
  fi
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
fi

export no_proxy="localhost,127.0.0.1,*.ge.com,192.168.0.*"
