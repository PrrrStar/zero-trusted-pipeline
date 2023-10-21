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
VAULT_OAUTH_CLIENT_ID=""
VAULT_OAUTH_CLIENT_SECRET=""

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
  -i | oauth-client-id)
    if [ -n "$2" ]; then
      VAULT_OAUTH_CLIENT_ID=$2
      export VAULT_OAUTH_CLIENT_ID="${VAULT_OAUTH_CLIENT_ID}"
      shift 2
    else
      echo "Error: Argument for $1 is missing" >&2
      exit 1
    fi
    ;;
  -s | oauth-client-secret)
    if [ -n "$2" ]; then
      VAULT_OAUTH_CLIENT_SECRET=$2
      export VAULT_OAUTH_CLIENT_SECRET="${VAULT_OAUTH_CLIENT_SECRET}"
      masked_secret=$(printf '%*s' "${#VAULT_OAUTH_CLIENT_SECRET}" | tr ' ' '*')
      shift 2
    else
      echo "Error: Argument for $1 is missing" >&2
      exit 1
    fi
    ;;
  -h | --help)
    echo "Usage:  $0"
    echo "        -a | --addr                 %  (set VAULT_ADDR of ...)" >&2
    echo "        -t | --token                %  (set VAULT_TOKEN of ...)" >&2
    echo "        -i | --oauth-client-id      %  (set VAULT_OAUTH_CLIENT_ID of ...)" >&2
    echo "        -s | --oauth-client-secret  %  (set VAULT_OAUTH_CLIENT_SECRET of ...)" >&2
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

if [ -z "$VAULT_OAUTH_CLIENT_ID" ]; then
  echo "Error: VAULT_OAUTH_CLIENT_ID is not set. Use $0 -h (or --help) for help." >&2
  source $0 -h
  exit 1
fi

if [ -z "$VAULT_OAUTH_CLIENT_SECRET" ]; then
  echo "Error: VAULT_OAUTH_CLIENT_SECRET is not set. Use $0 -h (or --help) for help." >&2
  source $0 -h
  exit 1
fi

echo "=====INIT VAULT====="
echo " - VAULT_ADDR: ${VAULT_ADDR}"
echo " - VAULT_TOKEN: ${masked_token}"
echo " - VAULT_OAUTH_CLIENT_ID: ${VAULT_OAUTH_CLIENT_ID}"
echo " - VAULT_OAUTH_CLIENT_SECRET: ${masked_secret}"

vault write auth/oidc/config \
  oidc_discovery_url="https://accounts.google.com" \
  oidc_client_id="${VAULT_OAUTH_CLIENT_ID}" \
  oidc_client_secret="${VAULT_OAUTH_CLIENT_SECRET}" \
  default_role="default"

vault write auth/oidc/role/operator - <<EOF
{
    "role_type": "oidc",
    "user_claim": "email",
    "bound_audiences": "${VAULT_OAUTH_CLIENT_ID}",
    "allowed_redirect_uris": [
      "${VAULT_ADDR}/ui/vault/auth/oidc/oidc/callback",
      "${VAULT_ADDR}/oidc/callback"
    ],
    "oidc_scopes": ["openid","email","profile"],
    "user_claim_json_pointer": "true",
    "bound_claims": {
      "email": [
        "jmeef0802@gmail.com"
      ]
    },
    "policies": [
      "operator"
    ],
    "ttl": "10m"
}
EOF
