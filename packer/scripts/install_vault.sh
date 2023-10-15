#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT install_vault.sh: $1"
}

logger 'Starting Vault installation'
export VAULT_URL="https://releases.hashicorp.com/vault"
export VAULT_VERSION="1.15.0"


logger 'Updating repo'
sudo apt -y update
sudo apt -y upgrade

logger 'Installing utilities'
sudo apt -y install zip unzip
sudo apt -y install dialog apt-utils

logger 'Downloading Vault binary'
curl --silent --remote-name "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"

logger 'Downloading SHA sums'
curl --silent --remote-name "${VAULT_URL}/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS"

logger 'Downlaod SHA signature'
curl --silent --remote-name "${VAULT_URL}/${VAULT_VERSION}/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig"

logger 'Unzipping vault'
unzip vault_${VAULT_VERSION}_linux_amd64.zip

logger 'Setting up path'
sudo chown root:root vault
sudo mv vault /usr/local/bin/
vault --version

logger 'Setting Vault to use malloc without root'
sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault

logger 'Creating new user to run vault without root'
sudo useradd --system --home /etc/vault.d --shell /bin/false vault