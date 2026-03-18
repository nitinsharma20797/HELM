#!/bin/bash

# 1. Reach into the vault-0 pod to get the password
# We use 'jq' locally to parse the token, then 'kubectl exec' to ask Vault
DB_PASS=$(kubectl exec -n vault vault-0 -- env VAULT_TOKEN=$(jq -r ".root_token" cluster-keys.json) vault kv get -field=DB_PASSWORD secret/webapp/config)

# 2. Check if we actually got the password
if [ -z "$DB_PASS" ]; then
    echo "Error: Could not fetch password from Vault pod."
    exit 1
fi

# 3. Connect to MySQL using that variable
mysql -u root -p"$DB_PASS" -h 127.0.0.1
