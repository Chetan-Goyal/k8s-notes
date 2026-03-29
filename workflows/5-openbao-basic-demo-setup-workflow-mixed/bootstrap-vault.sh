#!/bin/bash

set -e

# ---------------- CONFIG ----------------
VAULT_POD="openbao-0"
VAULT_NS="openbao"
ENVIRONMENTS=("staging")
SERVICES=("orders-api" "payments-api")

# ----------------------------------------

echo "Starting Vault bootstrap..."

for env in "${ENVIRONMENTS[@]}"; do
  for svc in "${SERVICES[@]}"; do

    echo "----------------------------------------"
    echo "Configuring: $svc (env: $env)"

    kubectl exec -i $VAULT_POD -n $VAULT_NS -- sh <<EOF
export BAO_ADDR=http://127.0.0.1:8200

echo "Writing policy..."
bao policy write ${svc}-${env}-policy - <<EOP
path "kv/data/${env}/${svc}/*" {
  capabilities = ["read"]
}
EOP

echo "Writing role..."
bao write auth/kubernetes/role/${svc}-${env}-role \
  bound_service_account_names=${svc} \
  bound_service_account_namespaces=${env} \
  policies=${svc}-${env}-policy \
  ttl=1h

echo "Done: ${svc}-${env}"
EOF

  done
done

echo "----------------------------------------"
echo "Vault bootstrap completed."
