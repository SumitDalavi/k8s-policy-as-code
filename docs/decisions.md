# Decisions

## ADR-001: Kyverno over OPA Gatekeeper
**Date:** 2026-08-29  
**Status:** Accepted

**Context:**  
Platform teams need to write, audit, and deploy admission control policies without learning complex new languages.

**Decision:**  
We selected Kyverno because its policies are written in native Kubernetes YAML, compared to OPA Gatekeeper which requires Rego.

**Consequences:**  
- ✅ Lower barrier to entry for DevOps engineers.
- ✅ Easier to integrate with existing YAML validation tools.
- ⚠️ Less portable outside of Kubernetes than OPA.

## ADR-002: Multi-Tier Verification & OCI Dual Distribution
- **Context:** Declarative infrastructure and policy catalogs required robust local simulation gates without imposing cloud provider dependencies or credentials during CI/CD.
- **Decision:** Establish a strict 3-tier verification model (offline linting → sandbox cluster test → GitOps deployment) and distribute validated release packages with SBOMs and OCI container/chart registries.
- **Consequences:** 
  - *Pros:* Zero cloud credentials required for CI validation; verifiable supply-chain integrity via Syft SBOMs.
  - *Cons:* Requires maintaining local test fixtures and mock plan inputs.
