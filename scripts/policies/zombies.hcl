# Manage the SSH backend
path "ssh/creds/zombies/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "ssh/sign/zombies/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "ssh/sign/zombies" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "sys/mounts" {
   capabilities = ["read"]
}
