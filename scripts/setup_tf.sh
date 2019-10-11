#!/usr/bin/env bash
# Vagrantbox Provison script for Terraform
# Warning : non-priviliged provision! for "vagrant" user


# 1.  check & install tools 
which wget || (
  sudo apt-get -qq install -y wget
  echo Installed wget  
) 
# unzip is not installed by default in most Linux distributions
which unzip || (
  sudo apt-get -qq install -y unzip
  echo Installed unzip
) 

# 2. Terraform download 
TF_VERSION="0.11.14"
#https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip

which terraform || (
# wget -nv - here nv to avoid clutter on screen when provisioning  
  wget -nv --directory-prefix=/tmp "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
  sudo unzip -q /tmp/terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/
)
terraform -version
