#!/usr/bin/env bash

function setProxy {
    export http_proxy=http://3.20.128.6:88
    export https_proxy=http://3.20.128.6:88
    export HTTP_PROXY=http://3.20.128.6:88
    export HTTPS_PROXY=http://3.20.128.6:88
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxystate Wi-Fi on
    sudo networksetup -setsecurewebproxystate Wi-Fi on
    return 0
}

function removeProxy {
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    sudo networksetup -setautoproxystate Wi-Fi off
    sudo networksetup -setwebproxystate Wi-Fi off
    sudo networksetup -setsecurewebproxystate Wi-Fi off
    return 0
}

alias mtproxy=setProxy
alias rmproxy=removeProxy

ip=$(ipconfig getifaddr en0)

if [[ $ip == 10.189* ]]; then 
    export http_proxy=http://3.20.128.6:88
    export https_proxy=http://3.20.128.6:88
    export HTTP_PROXY=http://3.20.128.6:88
    export HTTPS_PROXY=http://3.20.128.6:88
fi

export no_proxy=localhost,*.ge.com,10/8,127/8,192/8
export NO_PROXY=localhost,*.ge.com,10/8,127/8,192/8
