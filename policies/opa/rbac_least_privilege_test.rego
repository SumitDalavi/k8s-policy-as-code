package rbac_test
import future.keywords.if
import future.keywords.in

import data.rbac

test_deny_cluster_admin_binding if {
    count(rbac.deny) > 0 with input as {
        "kind": "ClusterRoleBinding",
        "metadata": {"name": "bad-binding"},
        "roleRef": {"name": "cluster-admin"},
        "subjects": [{"name": "developer", "kind": "User"}]
    }
}

test_allow_system_account_cluster_admin if {
    count(rbac.deny) == 0 with input as {
        "kind": "ClusterRoleBinding",
        "metadata": {"name": "ok-binding"},
        "roleRef": {"name": "cluster-admin"},
        "subjects": [{"name": "system:kube-scheduler", "kind": "User"}]
    }
}

test_deny_wildcard_verbs if {
    count(rbac.deny) > 0 with input as {
        "kind": "ClusterRole",
        "metadata": {"name": "too-broad"},
        "rules": [{"apiGroups": [""], "verbs": ["*"], "resources": ["pods"]}]
    }
}
