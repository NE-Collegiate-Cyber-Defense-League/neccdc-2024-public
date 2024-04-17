path "/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "secret/*" {
capabilities = ["read", "create", "update", "delete", "list"]
}
path "kv/*" {
capabilities = ["read", "create", "update", "delete", "list"]
}
path "sys/*" {
capabilities = ["read", "create", "update", "delete", "list"]
}
