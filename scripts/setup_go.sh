#!/usr/bin/env bash
# Vagrantbox Provison script for GoLang
# Warning : non-priviliged provision! for "vagrant" user

# 1. GoLang install
GO_DISTRO="go1.13.linux-amd64.tar.gz"
# update system
#sudo apt-get update
#sudo apt-get -y upgrade
# install wget 
which wget || (
  sudo apt-get -qq install -y wget
) 
# 2. Downloadn and install Go
# wget -nv - here nv to avoid clutter on screen when provisioning  
which go || (
  wget -nv --directory-prefix=/tmp https://dl.google.com/go/${GO_DISTRO}
  sudo tar -C /usr/local/ -xf /tmp/${GO_DISTRO}
)

# 3. Configure GO Environment
# - for one-time executio
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
# - make Go home
mkdir -p $HOME/go
# - profile configuration, Bash is default in Ubuntu Bionic Beaver
cat << EOF >> $HOME/.bash_profile
# -> GoLang environment env var definitions :
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
# ^- end of GoLang environment env vars definition block.
EOF

