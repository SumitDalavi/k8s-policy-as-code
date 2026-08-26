package rbac

import future.keywords.if
import future.keywords.in

# Deny ClusterRoleBindings that grant cluster-admin to non-system accounts
deny[msg] if {
    input.kind == "ClusterRoleBinding"
    input.roleRef.name == "cluster-admin"
    some subject in input.subjects
    not startswith(subject.name, "system:")
    msg := sprintf("ClusterRoleBinding '%v' grants cluster-admin to non-system account '%v'",
                   [input.metadata.name, subject.name])
}

# Deny wildcard verb grants on core resources
deny[msg] if {
    input.kind in ["Role", "ClusterRole"]
    some rule in input.rules
    "*" in rule.verbs
    "" in rule.apiGroups  # core API group
    msg := sprintf("Role/ClusterRole '%v' grants wildcard verbs on core API resources",
                   [input.metadata.name])
}
