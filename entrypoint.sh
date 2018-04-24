#!/bin/bash
set -euo pipefail

LOCAL_VAULT_ADDR=${LOCAL_VAULT:-http://vault:8200}
UNSEAL_TOKEN_FIELD=${UNSEAL_TOKEN_FIELD:-token}
UNSEAL_TOKEN_PATH=${UNSEAL_TOKEN_PATH:-secret/mgmt/unseal}
LIVE_VAULT_ADDR=${VAULT_ADDR}  # Fail if unset
VAULT_ROLE_ID=${VAULT_ROLE_ID} # Fail if unset

function authenticate() {
	export VAULT_ADDR=${LIVE_VAULT_ADDR}
	vault write -field=token auth/approle/login role_id=${VAULT_ROLE_ID}
}

function getUnsealKey() {
	export VAULT_ADDR=${LIVE_VAULT_ADDR}
	vault read -field=${UNSEAL_TOKEN_FIELD} ${UNSEAL_TOKEN_PATH}
}

function isSealed() {
	curl -s ${LOCAL_VAULT}/v1/sys/health | jq -e '.sealed == true'
}

function main() {
	isSealed || {
		echo "Already unsealed."
		return 0
	}

	export VAULT_TOKEN=$(authenticate)
	UNSEAL_TOKEN=$(getUnsealKey)

	unseal "${UNSEAL_TOKEN}"

	isSealed && {
		echo "Unseal failed!"
		return 1
	}
}

function unseal() {
	export VAULT_ADDR=${LOCAL_VAULT_ADDR}
	vault operator unseal "$1"
}

while [ 1 ]; do
	main && break || sleep 10
done
