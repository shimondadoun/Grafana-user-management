resource "grafana_user" "users" {
  for_each = { for user in var.grafana_users : user.login => user }
  
  name     = each.value.name
  email    = each.value.email
  login    = each.value.login
  password = try(data.vault_generic_secret.grafana_passwords.data[each.value.login],
   data.vault_generic_secret.grafana_default_password.data["password"])

  depends_on = [
    helm_release.grafana,
    data.vault_generic_secret.grafana_passwords, 
    data.vault_generic_secret.grafana_default_password
    ]
}
