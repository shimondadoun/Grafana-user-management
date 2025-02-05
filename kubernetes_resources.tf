resource "kubernetes_namespace" "grafana" {
  metadata {
    name = var.grafana_namespace
  }
  depends_on = [null_resource.kube_context_switch]
}


data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.grafana_namespace
  }
  depends_on = [helm_release.grafana]
}


resource "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = var.grafana_namespace
  }

  data = {
    admin-user     = var.grafana_admin_user
    admin-password = data.vault_generic_secret.grafana_admin_password.data["password"]
  }

  type = "Opaque"

  depends_on = [null_resource.kube_context_switch, data.vault_generic_secret.grafana_admin_password]
}
