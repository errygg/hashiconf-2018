# Manage the SSH backend
path "ssh/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "sys/mounts" {
   capabilities = ["read"]
}
