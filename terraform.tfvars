grafana_org_name = "MyCompanyOrg"
grafana_admin_user = "admin"
grafana_namespace = "monitoring"
grafana_port = "32005"
grafana_users = [
  {
    name     = "Big Boss"
    email    = "bigboss@example.com"
    login    = "bigboss"
    role     = "Admin"    
  },
  {
    name     = "Developer"
    email    = "developer@example.com"
    login    = "developer"
    role     = "Editor"    
  },
  {
    name     = "Visitor"
    email    = "visitor@example.com"
    login    = "visitor"
    role     = "Viewer"    
  }
]

kubernetes_cluster_name = "monitoring"
vault_address = "http://127.0.0.1:8200"