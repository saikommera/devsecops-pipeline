# App production policy — least privilege
path "secret/data/prod/*" {
  capabilities = ["read"]
}

path "secret/metadata/prod/*" {
  capabilities = ["list", "read"]
}

# Database dynamic credentials
path "database/creds/prod-app-role" {
  capabilities = ["read"]
}

# PKI certificates
path "pki/issue/prod-app" {
  capabilities = ["create", "update"]
}

# Deny writes to production secrets from app role
path "secret/data/prod/infra/*" {
  capabilities = ["deny"]
}
