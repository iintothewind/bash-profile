#!/usr/bin/env bash

# local proxy settings
function setLocalProxy {
  export http_proxy=http://localhost:1080
  export https_proxy=http://localhost:1080
  export HTTP_PROXY=http://localhost:1080
  export HTTPS_PROXY=http://localhost:1080
  
  #export http_proxy=http://192.168.0.183:1080
  #export https_proxy=http://192.168.0.183:1080
  #export HTTP_PROXY=http://192.168.0.183:1080
  #export HTTPS_PROXY=http://192.168.0.183:1080
  return 0
}

function removeLocalProxy {
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  return 0
}

# GE Proxy settings
function setGeProxy {
  export http_proxy=http://3.20.128.6:88
  export https_proxy=http://3.20.128.6:88
  export HTTP_PROXY=http://3.20.128.6:88
  export HTTPS_PROXY=http://3.20.128.6:88
  sudo networksetup -setautoproxystate Wi-Fi off
  sudo networksetup -setwebproxystate Wi-Fi on
  sudo networksetup -setsecurewebproxystate Wi-Fi on
  return 0
}

function removeGeProxy {
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  sudo networksetup -setautoproxystate Wi-Fi off
  sudo networksetup -setwebproxystate Wi-Fi off
  sudo networksetup -setsecurewebproxystate Wi-Fi off
  return 0
}



if [[ $(uname) == Linux ]]; then
  alias mtproxy=setLocalProxy
  alias rmproxy=removeLocalProxy
  if [[ $(netstat -tln|grep 1080) == tcp*0.0.0.0*1080*LISTEN* ]]; then 
    export http_proxy=http://localhost:1080
    export https_proxy=http://localhost:1080
    export HTTP_PROXY=http://localhost:1080
    export HTTPS_PROXY=http://localhost:1080
  fi

  #if [[ $(nmap 192.168.0.183 -p 1080) == *open* ]]; then
  #  export http_proxy=http://192.168.0.183:1080
  #  export https_proxy=http://192.168.0.183:1080
  #  export HTTP_PROXY=http://192.168.0.183:1080
  #  export HTTPS_PROXY=http://192.168.0.183:1080
  #fi
fi

if [[ $(uname) == Darwin ]]; then
  alias mtproxy=setGeProxy
  alias rmproxy=removeGeProxy
  if [[ $(ipconfig getifaddr en0) == 10.189* ]]; then 
      export http_proxy=http://3.20.128.6:88
      export https_proxy=http://3.20.128.6:88
      export HTTP_PROXY=http://3.20.128.6:88
      export HTTPS_PROXY=http://3.20.128.6:88
  fi
fi


export no_proxy=localhost,*.ge.com,10/8,127/8,192/8
export NO_PROXY=localhost,*.ge.com,10/8,127/8,192/8
