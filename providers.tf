terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "2.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.1.1"
    }
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "~> 0.0.7"
    }
    vault = {
      source = "hashicorp/vault"
      version = "~> 3.1.1"
    }

  }
}
provider k3d {}

provider null {}

provider "grafana" {
  url  = "http://localhost:${var.grafana_port}"
  auth = "${var.grafana_admin_user}:${resource.kubernetes_secret.grafana_admin.data["admin-password"]}"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  insecure    = true # For k3d
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
  }
}

provider "vault" {
  address = var.vault_address
  token = var.vault_token
}