# 🔐 DevSecOps Pipeline

[![DevSecOps](https://img.shields.io/badge/DevSecOps-Shift--Left-red?style=flat-square)](https://owasp.org)
[![SonarQube](https://img.shields.io/badge/SonarQube-SAST-4E9BCD?style=flat-square&logo=sonarqube)](https://sonarqube.org)
[![Trivy](https://img.shields.io/badge/Trivy-Container%20Scan-1904DA?style=flat-square)](https://aquasecurity.github.io/trivy)
[![Vault](https://img.shields.io/badge/HashiCorp-Vault-000000?style=flat-square&logo=vault)](https://vaultproject.io)

Comprehensive DevSecOps shift-left pipeline integrating SAST, container scanning, secrets detection, dependency auditing, OPA policy-as-code, and HashiCorp Vault secrets management.

## 🛡️ Security Gates

```
Code Push → Gitleaks → SAST (SonarQube) → SCA (Snyk) → Build →
Trivy Scan → OPA Policy Check → Deploy Staging → DAST → Deploy Prod
```

## 🔧 Tools Integrated

| Tool | Category | Purpose |
|---|---|---|
| Gitleaks | Secrets Detection | Pre-commit and CI secrets scanning |
| SonarQube | SAST | Static code analysis, code quality |
| Snyk | SCA | Dependency vulnerability scanning |
| Trivy | Container Scanning | Docker image CVE detection |
| OWASP ZAP | DAST | Runtime API security testing |
| OPA / Conftest | Policy-as-Code | Terraform and K8s policy enforcement |
| HashiCorp Vault | Secrets Management | Dynamic credentials, secrets injection |

## 🚀 Quick Start

```bash
# Install pre-commit hooks (prevents secrets from being committed)
pip install pre-commit
pre-commit install

# Run full security scan locally
docker run --rm -v $(pwd):/src aquasec/trivy fs /src
docker run --rm -v $(pwd):/path zricethezav/gitleaks detect --source /path
```

## 📋 OPA Policy Example

```rego
# Deny Terraform resources without required tags
package terraform.aws

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"
  not resource.change.after.tags["Environment"]
  msg := sprintf("EC2 instance '%v' missing required 'Environment' tag", [resource.address])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.change.after.tags["Environment"]
  valid_envs := {"dev", "staging", "prod"}
  not valid_envs[resource.change.after.tags["Environment"]]
  msg := sprintf("Invalid Environment tag value '%v'", [resource.change.after.tags["Environment"]])
}
```

## 🔑 Vault Secrets Injection

```yaml
# Kubernetes annotation-based secrets injection
annotations:
  vault.hashicorp.com/agent-inject: "true"
  vault.hashicorp.com/role: "app-role"
  vault.hashicorp.com/agent-inject-secret-db: "secret/data/prod/database"
  vault.hashicorp.com/agent-inject-template-db: |
    {{- with secret "secret/data/prod/database" -}}
    export DB_HOST="{{ .Data.data.host }}"
    export DB_PASSWORD="{{ .Data.data.password }}"
    {{- end -}}
```

## 🧑‍💻 Author

**Sai Babji Kommera** — Senior DevOps / SRE Engineer
[LinkedIn](https://www.linkedin.com/in/sai-babji-kommera-a3b953396/) · saibabji1@gmail.com
