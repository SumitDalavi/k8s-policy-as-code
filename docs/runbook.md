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
