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
