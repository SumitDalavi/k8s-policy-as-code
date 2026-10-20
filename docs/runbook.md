# Runbook — k8s-policy-as-code
> Last updated: 2026-08-29

## Quick Start
```bash
# Bring up the cluster and deploy Kyverno
kind create cluster --name policy-lab
helm repo add kyverno https://kyverno.github.io/kyverno/
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
```

## Run Tests / Demos
```bash
bash scripts/demo_policy_exception_lifecycle.sh
```

## Failure Modes
| Symptom | Cause | Fix |
|---|---|---|
| Legitimate pod blocked | Policy too strict or missing PolicyException | Create a PolicyException CRD for the specific namespace/pod |


---

## Release Runbook

### Release Trigger
Tag push matching `v*.*.*` (e.g., `v0.1.0`).

### Automated Pipeline Stages
1. **Quality & Validation Gate:** Validates policy syntax, Rego rules, and manifest schemas.
2. **Distribution Packaging:** Bundles clean production manifests into `k8s-policy-as-code-<tag>.tar.gz` and calculates SHA256 checksums.
3. **Syft Source SBOM:** Generates `sbom.spdx.json` adhering to SPDX 2.3 standard.
4. **GitHub Release:** Publishes release assets and release notes.

### Verification
```bash
gh release view v0.1.0 --repo SumitDalavi/k8s-policy-as-code
gh release download v0.1.0 --repo SumitDalavi/k8s-policy-as-code --pattern "checksums.txt"
```

### Failure Modes & Remediation
- **Linter / Test Failure:** Inspect policy syntax or module arguments locally before tagging.
- **Checksum Mismatch:** Ensure file was completely downloaded without network truncation.
