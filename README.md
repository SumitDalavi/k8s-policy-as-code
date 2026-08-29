# Kubernetes Policy-as-Code Security Platform 🛡️📜

> **Maturity:** Lab / Reference Implementation
> _A comprehensive suite of Kubernetes admission controls using Kyverno, enforcing strict security standards (Pod Security Standards, Network Policies, Image Provenance) before workloads ever hit the cluster._

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


## 📋 Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | >= 1.28 | Kubernetes CLI |
| [kind](https://kind.sigs.k8s.io/) or [minikube](https://minikube.sigs.k8s.io/) | Latest | Local K8s cluster |
| [Helm](https://helm.sh/) | >= 3.x | Package manager |

## 🚀 Step-by-Step Setup

### Option A: Local Cluster (kind)

```bash
# 1. Clone the repository
git clone https://github.com/SumitDalavi/k8s-policy-as-code.git
cd k8s-policy-as-code

# 2. Create a local cluster
kind create cluster --name policy-lab

# 3. Install Kyverno (policy engine)
helm repo add kyverno https://kyverno.github.io/kyverno/
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace

# 4. Apply the policies
kubectl apply -f policies/pod-security/disallow-privileged.yaml
kubectl apply -f policies/network/require-network-policy.yaml
```

### Option B: Existing Cloud Cluster

```bash
kubectl cluster-info
# Follow steps 3-4 from Option A
```

## 🧪 Usage & Demo

### Step 1: Verify policies are active
```bash
kubectl get clusterpolicies
```

### Step 2: Test policy enforcement â€” Privileged pod (should be BLOCKED)
```bash
# Try to create a privileged pod â€” Kyverno should deny it
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod
spec:
  containers:
  - name: test
    image: nginx
    securityContext:
      privileged: true
EOF
# Expected: Error from server: admission webhook denied the request
```

### Step 3: Test policy enforcement â€” Safe pod (should be ALLOWED)
```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: good-pod
spec:
  containers:
  - name: test
    image: nginx
    securityContext:
      privileged: false
EOF
# Expected: pod/good-pod created
```

### Step 4: Run policy tests
```bash
kubectl apply -f tests/disallow-privileged-test.yaml
```

## ✅ Verification

| Check | Command | Expected |
|-------|---------|----------|
| Kyverno running | `kubectl get pods -n kyverno` | Controller pods running |
| Policies active | `kubectl get clusterpolicies` | Policies in Ready state |
| Bad pod blocked | Apply privileged pod | Admission denied |
| Good pod allowed | Apply non-privileged pod | Pod created |

```bash
# Cleanup
kind delete cluster --name policy-lab
```

## 👨‍💻 Author

**Sumit Dalavi** — Senior DevSecOps / Platform Engineer
[GitHub](https://github.com/SumitDalavi) | [LinkedIn](https://in.linkedin.com/in/sumit-dalavi-762838129)

## 📚 Documentation

- [Architecture](docs/ARCHITECTURE.md) — System diagram and component details
- [Runbook](docs/runbook.md) — Setup, commands, and expected outputs
- [Decisions](docs/decisions.md) — ADRs for policy engine
- [Changelog](docs/changelog.md) — Change history
- [Impact Report](docs/impact_report.md) — Before and After policy impact

## Mock Boundaries (Honest Scope)

| What | Status | Details |
|---|---|---|
| Policy Engine (Kyverno) | **Real** | Helm deployment of actual Kyverno controller. |
| Kubernetes API | **Real** | Evaluates real `AdmissionReview` requests in `kind`. |
| CI Pipeline Testing | **Simulated** | E2E demo scripts validate policy logic locally instead of running inside a GitHub Action runner. |

## 🔗 Related Projects

- [`supply-chain-security-pipeline`](../supply-chain-security-pipeline/) — Generates the signatures that Kyverno verifies.