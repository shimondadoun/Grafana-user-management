data "vault_generic_secret" "grafana_default_password" {
  path = "secrets/grafana/default_password"
}

data "vault_generic_secret" "grafana_admin_password" {
  path = "secrets/grafana/admin_password"
}

data "vault_generic_secret" "grafana_passwords" {
  path = "secrets/grafana/users"
}