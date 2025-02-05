resource "k3d_cluster" "monitoring-cluster" {
  name    = var.kubernetes_cluster_name
  servers = 1
  agents  = 2

  kube_api {
    host      = "0.0.0.0"
    host_ip   = "127.0.0.1"
    host_port = 6443
  }

  image   = "rancher/k3s:v1.20.4-k3s1"

  port {
    host_port      = var.grafana_port
    container_port = var.grafana_port
    node_filters = [
      "loadbalancer",
    ]
  }

  k3d {
    disable_load_balancer     = false
    disable_image_volume      = false
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}


resource "null_resource" "kube_context_switch" {
  # depends_on = [helm_release.grafana]  # Ensure Helm deploys first

  provisioner "local-exec" {
    command = "kubectl config use-context k3d-${var.kubernetes_cluster_name}"
  }

  depends_on = [k3d_cluster.monitoring-cluster]
}