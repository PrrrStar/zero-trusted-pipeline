#!/bin/bash

set -e
if [ "$(dirname $0)" != "." ]; then
  echo "you should execute this script on tools directory"
  exit 1
fi
CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# default options:
VAULT_ADDR=""
VAULT_TOKEN=""

# directory containing policies
POLICIES_DIR="../"

# get options:
while (("$#")); do
  case "$1" in
  -a | --addr)
    if [ -n "$2" ]; then
      VAULT_ADDR=$2
      export VAULT_ADDR=$VAULT_ADDR
      shift 2
    else
      echo "Error: Argument for $1 is missing" >&2
      exit 1
    fi
    ;;
  -t | --token)
    if [ -n "$2" ]; then
      VAULT_TOKEN=$2
      export VAULT_TOKEN="${VAULT_TOKEN}"
      masked_token=$(printf '%*s' "${#VAULT_TOKEN}" | tr ' ' '*')
      shift 2
    else
      echo "Error: Argument for $1 is missing" >&2
      exit 1
    fi
    ;;
  -h | --help)
    echo "Usage:  $0"
    echo "        -a | --addr       %  (set VAULT_ADDR of ...)" >&2
    echo "        -t | --token      %  (set VAULT_TOKEN of ...)" >&2
    exit 0
    ;;

  -* | --*) # unsupported flags
    echo "Error: Unsupported flag: $1" >&2
    echo "$0 -h for help message" >&2
    exit 1
    ;;
  *)
    echo "Error: Arguments with not proper flag: $1" >&2
    echo "$0 -h for help message" >&2
    exit 1
    ;;
  esac
done

if [ -z "$VAULT_TOKEN" ]; then
  echo "Error: VAULT_TOKEN is not set. Use $0 -h (or --help) for help." >&2
  source $0 -h
  exit 1
fi


echo "=====INIT VAULT====="
echo " - VAULT_ADDR: ${VAULT_ADDR}"
echo " - VAULT_TOKEN: ${masked_token}"

vault write auth/approle/role/iise-github-deployer token_policies="iise-github-deployer"
vault read auth/approle/role/iise-github-deployer/role-id
vault write -force auth/approle/role/iise-github-deployer/secret-id