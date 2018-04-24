# luzifer-docker / vault-self-unseal

Contains a script to unseal a local Vault instance as part of a Vault cluster which leader currently is unsealed. As long as there is one unsealed leader this script can unseal the local instance, if there is no unsealed leader left the unseal will fail.

## Usage

```bash
## Build container (optional)
$ docker build -t luzifer/vault-self-unseal .

## Execute vault-self-unseal
$ docker run --rm -ti -e LIVE_VAULT_ADDR=https://myvault.example.com -e VAULT_ROLE_ID=some-uuid luzifer/vault-self-unseal
```
