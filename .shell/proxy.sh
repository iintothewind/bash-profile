#!/usr/bin/env bash

# local proxy settings
function setLocalProxy {
  export http_proxy=http://localhost:8123
  export https_proxy=http://localhost:8123
  export HTTP_PROXY=http://localhost:8123
  export HTTPS_PROXY=http://localhost:8123
  return 0
}

# GE Proxy settings
function setGeProxy {
  export http_proxy=http://3.20.128.6:88
  export https_proxy=http://3.20.128.6:88
  export HTTP_PROXY=http://3.20.128.6:88
  export HTTPS_PROXY=http://3.20.128.6:88
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxy Wi-Fi 3.20.128.6 88
    sudo networksetup -setsecurewebproxy Wi-Fi 3.20.128.6 88
    sudo networksetup -setdnsservers Wi-Fi Empty
  fi
  return 0
}

# Shadowsocks Proxy settings
function setShadowSocksProxy {
  export http_proxy=http://192.168.0.161:8123
  export https_proxy=http://192.168.0.161:8123
  export HTTP_PROXY=http://192.168.0.161:8123
  export HTTPS_PROXY=http://192.168.0.161:8123
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxy Wi-Fi 192.168.0.161 8123
    sudo networksetup -setsecurewebproxy Wi-Fi 192.168.0.161 8123
    sudo networksetup -setdnsservers Wi-Fi 115.159.96.69 115.159.157.26 115.159.158.38 115.159.220.214
  fi
  return 0
}

function removeProxy {
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  if [[ "$JAVA_OPTS" == *http* ]]; then
    unset JAVA_OPTS
  fi
  if type networksetup > /dev/null 2>&1; then
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxystate Wi-Fi off
    sudo networksetup -setsecurewebproxystate Wi-Fi off
  fi
  return 0
}

function getProxyStatus {
  echo "http_proxy=$http_proxy"
  echo "https_proxy=$https_proxy"
  echo "HTTP_PROXY=$HTTP_PROXY"
  echo "HTTPS_PROXY=$HTTPS_PROXY"
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
  alias proxystatus=getProxyStatus
  if [[ $(netstat -tln|grep 1080) == tcp*0.0.0.0*1080*LISTEN* ]]; then 
    export http_proxy=http://localhost:8123
    export https_proxy=http://localhost:8123
    export HTTP_PROXY=http://localhost:8123
    export HTTPS_PROXY=http://localhost:8123
  fi

  #if [[ $(nmap 192.168.0.161 -p 1080) == *open* ]]; then
  #  export http_proxy=http://192.168.0.161:8123
  #  export https_proxy=http://192.168.0.161:8123
  #  export HTTP_PROXY=http://192.168.0.161:8123
  #  export HTTPS_PROXY=http://192.168.0.161:8123
  #fi
fi

if [[ $(uname) == Darwin ]]; then
  alias mtproxy=setGeProxy
  alias mtscproxy=setShadowSocksProxy
  alias rmproxy=removeProxy
  alias proxystatus=getProxyStatus
  if [[ $(ipconfig getifaddr en0) == 10.189* ]]; then 
      export http_proxy=http://3.20.128.6:88
      export https_proxy=http://3.20.128.6:88
      export HTTP_PROXY=http://3.20.128.6:88
      export HTTPS_PROXY=http://3.20.128.6:88
  fi
fi

export no_proxy=localhost,*.ge.com,10/8,127/8,192/8
export NO_PROXY=localhost,*.ge.com,10/8,127/8,192/8
