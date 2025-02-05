resource "helm_release" "grafana" {
  name       = "grafana"
  repository = var.grafana_helm_chart.repository
  chart      = var.grafana_helm_chart.name
  version    = var.grafana_helm_chart.version
  namespace  = kubernetes_namespace.grafana.metadata[0].name

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = var.grafana_port
  }

  set {
    name  = "grafana.ini.auth.allowSignUp"
    value = "false"
  }

  set {
    name  = "admin.existingSecret"
    value = "grafana-admin-secret"
  }

  set {
    name  = "admin.userKey"
    value = "admin-user"
  }

  set {
    name  = "admin.passwordKey"
    value = "admin-password"
  }

  depends_on = [kubernetes_secret.grafana_admin, kubernetes_namespace.grafana]
}
