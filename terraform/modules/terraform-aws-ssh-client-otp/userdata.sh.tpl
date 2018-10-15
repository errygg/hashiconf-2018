#!/bin/bash
# User Data script used to setup the target OTP host. This could also be done
# using a configuration management tool such as Chef, Ansible, etc.

echo "Update packages and install vault-ssh-helper"
apt-get update
apt-get install -y unzip

mkdir -p /etc/vault-ssh-helper.d
mkdir -p /usr/local/bin
cd /usr/local/bin
wget https://releases.hashicorp.com/vault-ssh-helper/0.1.4/vault-ssh-helper_0.1.4_linux_amd64.zip -O tmp.zip && unzip tmp.zip && rm tmp.zip

echo "Create vault-ssh-helper configuration"
cat << EOF > /etc/vault-ssh-helper.d/config.hcl
vault_addr = "http://${vault_addr}"
ssh_mount_point = "${namespace}/ssh"
tls_skip_verify = true
allowed_roles = "${roles}"
allowed_cidr_list="${cidrs}"
EOF

echo "Update PAM sshd configuration"
sed -i 's/@include common-auth/#@include common-auth/' /etc/pam.d/sshd
sed -i '/#@include common-auth/ i\
auth requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -config=/etc/vault-ssh-helper.d/config.hcl\
auth optional pam_unix.so not_set_pass use_first_pass nodelay' /etc/pam.d/sshd

echo "Update sshd configuration"
sed -i '/ChallengeResponseAuthentication/ s/no/yes/' /etc/ssh/sshd_config
sed -i '/UsePAM/ s/no/yes/' /etc/ssh/sshd_config

service sshd restart

echo "Create user 'bob'"
useradd -ms /bin/bash bob
usermod -aG sudo bob
