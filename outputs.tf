output "grafana_url" {
  description = "Grafana URL"
  value = "http://localhost:${var.grafana_port}"
}