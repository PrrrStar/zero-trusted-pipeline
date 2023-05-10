${vault_secondary_start}


logger 'Waiting for Vault service to become active'
while true; do
if [ $(systemctl is-active vault.service) == "active" ]; then
break
fi
sleep 1
done

logger 'Sleeping for 10 seconds for Vault to become available'
sleep 10

logger 'Attempting Init'
mkdir -p /etc/vault
vault operator init > /etc/vault/init.file