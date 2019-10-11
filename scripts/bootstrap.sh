#!/usr/bin/env bash
# Vagrantbox Full Provison script for our task

bash scripts/setup_go.sh
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while provisioning GO lang"
  exit 1
fi
bash scripts/setup_tf.sh
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while provisioning Terraform"
  exit 1
fi
bash scripts/setup_custom_plugin.sh
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while provisioning Custom Terraform plugin"
  exit 1
fi
bash scripts/init_tf.sh
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while initializing Terraform"
  exit 1
fi
bash scripts/test_tf.sh
ret_code=$?
if [ $ret_code -ne 0 ]; then
  echo "Error while running test"
fi
