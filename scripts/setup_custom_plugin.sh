#!/usr/bin/env bash
# Vagrantbox Provison script for Terraform
# Warning : non-priviliged provision! for "vagrant" user


# 1. Install Git
which git || (
  sudo apt-get -qq install -y git
  echo Installed wget  
)

# re-export go env vars for compile time
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# 2. Get code
go get github.com/petems/terraform-provider-extip
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while downloading provider"
  exit 1
fi
#. 3 Build it
cd $GOPATH/src/github.com/petems/terraform-provider-extip/
make build
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while building provider"
  echo "Check the compiler errors above"
  exit 1
fi
# 4. Make folder and link plugin
mkdir -p $HOME/.terraform.d/plugins/
[ -f $HOME/.terraform.d/plugins/terraform-provider-extip ] || (
  ln -s $GOPATH/bin/terraform-provider-extip $HOME/.terraform.d/plugins/
)

