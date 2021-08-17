module "monitoring" {
  source = "./"

  nfs_endpoint           = "10.10.10.10"
  domain                 = "example.com"
  tls                    = "secret-tls"
  grafana_admin_password = "password"

  grafana_ldap_enable          = true
  grafana_ldap_host            = "domain.com"
  grafana_ldap_bind_dn         = "cn=reader,ou=users,ou=company,dc=example,dc=com"
  grafana_ldap_bind_password   = "password"
  grafana_ldap_search_base_dn  = "ou=company,dc=example,dc=com"
  grafana_ldap_search_filter   = "(&(sAMAccountName=%s)(memberOf=cn=grafana_users,ou=groups,ou=company,dc=example,dc=com))"
  grafana_ldap_admin_group_dn  = "cn=grafana_admin,ou=groups,ou=company,dc=example,dc=com"
  grafana_ldap_editor_group_dn = "cn=grafana_editor,ou=groups,ou=company,dc=example,dc=com"
}