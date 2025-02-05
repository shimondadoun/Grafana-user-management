variable "grafana_org_name" {
  description = "The name of the Grafana organization"
  type        = string
}

variable "grafana_port" {
  description = "The port to forward grafana to"
  type        = string
}

variable "grafana_admin_user" {
  description = "The name of the Grafana admin user"
  type        = string
}

variable "grafana_users" {
  description = "List of users to create in Grafana"
  type = list(object({
    name     = string
    email    = string
    login    = string
    role     = string
  }))
  
  validation {
    condition = alltrue([for user in var.grafana_users : contains(["Admin", "Editor", "Viewer"], user.role)])
    error_message = "Each user's role must be one of the following: Admin, Editor, or Viewer."
  }
}

variable "grafana_namespace" {
  description = "The namespace to deploy Grafana"
  type        = string
}

variable "grafana_helm_chart" {
  description = "Grafana Helm chart details"
  type = object({
    name       = string
    repository = string
    version    = string
  })
  default = {
    name       = "grafana"
    repository = "https://grafana.github.io/helm-charts"
    version    = "7.0.0"
  }
}

variable "kubernetes_cluster_name" {
  type = string
}

variable "vault_address" {
  type = string
}

variable "vault_token" {
  type      = string
  sensitive = true
}
