package kubernetes.admission

deny[msg] {
    input.request.kind.kind == "Deployment"
    not input.request.object.spec.template.spec.securityContext.runAsNonRoot
    msg := "Containers must not run as root"
}

deny[msg] {
    input.request.kind.kind == "Deployment"
    container := input.request.object.spec.template.spec.containers[_]
    not container.securityContext.allowPrivilegeEscalation == false
    msg := "Containers must not allow privilege escalation"
}
