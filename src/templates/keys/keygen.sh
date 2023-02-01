#!/usr/bin/env bash

domain_name=$1

if test -f "$HOME/.ssh/$domain_name"; then
  echo "[!!!] Operator already has an SSH key! Skipping key generation"
  exit
fi

if ! ssh-keygen -f "$HOME/.ssh/$domain_name" -q -N ""; then
  echo "[!!!] There was an error generating the SSH key for Terraform"
  exit
fi
