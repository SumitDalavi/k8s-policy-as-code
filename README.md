# Kubernetes Policy-as-Code Security Platform 🛡️📜

> A comprehensive suite of Kubernetes admission controls using Kyverno, enforcing strict security standards (Pod Security Standards, Network Policies, Image Provenance) before workloads ever hit the cluster.

## The Problem

Relying on developers to "remember" to not run containers as root, or to not mount the host filesystem, is a failed security strategy. Vulnerability scanners (SAST/DAST) catch bad code, but they don't prevent bad *infrastructure configurations* from being deployed to a cluster, leading to container escapes and cluster takeovers.

## The Solution

This project implements **Policy-as-Code** using Kyverno as a Kubernetes Admission Controller. 

Whenever an API request is made to Kubernetes (e.g., `kubectl apply` or an Argo CD sync), the request is intercepted by Kyverno webhooks. The policies defined in this repository evaluate the resource:
1. **Validation**: Rejects pods trying to run in privileged mode or mount sensitive host paths.
2. **Mutation**: Automatically injects standard sidecars or labels.
3. **Generation**: Automatically creates a default-deny NetworkPolicy whenever a new Namespace is created.

## Why This Over the Obvious Alternative

The alternative is Open Policy Agent (OPA) Gatekeeper. While OPA is powerful, it requires learning a complex, proprietary domain-specific language (Rego). Kyverno policies are written in native Kubernetes YAML, making them significantly easier for platform teams to write, audit, and maintain.

## 🛠️ Tech Stack

- **Policy Engine**: Kyverno
- **Cluster**: Kubernetes (AKS/EKS compatible)
- **CI Testing**: Kyverno CLI for policy validation in CI/CD

## Decision Log

| Decision | Rationale |
|----------|-----------|
| Kyverno over OPA Gatekeeper | Native YAML syntax drastically lowers the barrier to entry for DevOps engineers compared to OPA's Rego language. |
| Enforce vs Audit Mode | Policies are grouped. "Best practices" (like required labels) run in Audit mode to prevent breaking legacy apps. "Security critical" (like privileged containers) run in Enforce mode, actively blocking deployments. |
| Test-Driven Policies | Policies are code. They must have unit tests (passing and failing cases) defined in the `/tests` directory and verified in CI before deployment. |

## 📁 Project Structure

```
├── policies/
│   ├── pod-security/
│   │   └── disallow-privileged.yaml      # Blocks privileged containers
│   └── network/
│       └── require-network-policy.yaml   # Auto-generates NetPol for new namespaces
├── tests/
│   └── disallow-privileged-test.yaml     # Unit tests for Kyverno CLI
├── docs/ARCHITECTURE.md
└── README.md
```

## 👨‍💻 Author

*Built to demonstrate DevSecOps, cluster hardening, and Policy-as-Code engineering.*
