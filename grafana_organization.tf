resource "grafana_organization" "main_organization" {
  name         = var.grafana_org_name
  admin_user   = var.grafana_admin_user
  admins = [
    for user in var.grafana_users : user.email if user.role == "Admin" 
  ]
  editors = [
    for user in var.grafana_users : user.email if user.role == "Editor" 
  ]
  viewers = [
    for user in var.grafana_users : user.email if user.role == "Viewer" 
  ]
    depends_on = [grafana_user.users]
}
