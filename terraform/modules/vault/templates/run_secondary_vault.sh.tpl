set -e

logger() {
DT=$(date '+%Y/%m/%d %H:%M:%S')
echo "$DT start_vault.sh: $1"
}


logger 'Creating Vault configuration file'
mkdir -p /etc/vault.d
cat > /etc/vault.d/vault.hcl << EOF
${vault_config_hcl}
EOF

internal_ip=`hostname -i`
sed -i "s/INTERNAL_IP/$internal_ip/g" /etc/vault.d/vault.hcl

logger 'Creating Vault systemd service'
mkdir -p /etc/systemd/system
mkdir -p /logs/vault
cat > /etc/systemd/system/vault.service << EOF
[Unit]
Description=vault service
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl

[Service]
EnvironmentFile=-/etc/sysconfig/vault
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
StandardOutput=/logs/vault/output.log
StandardError=/logs/vault/error.log
LimitMEMLOCK=infinity
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

logger 'Starting Vault service'
systemctl start vault.service

logger 'Enabling automatic restart'
systemctl enable vault.service

logger 'Setting global value for VAULT_ADDR'
mkdir -p /etc/profile.d/
cat > /etc/profile.d/vault.sh << EOF
export VAULT_ADDR=http://127.0.0.1:8200
EOF

logger 'Setting VAULT_ADDR for this session'
export VAULT_ADDR=http://127.0.0.1:8200