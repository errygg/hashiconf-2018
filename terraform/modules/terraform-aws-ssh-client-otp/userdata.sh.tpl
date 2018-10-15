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
allowed_cidr_list="0.0.0.0/0"
EOF

echo "Update PAM sshd configuration"
sed -i '/@include common-auth/\
# HashiConf 2018: redirect pam authentications to exec the vault-ssh-helper instead of the common-auth\
#@include common-auth\
auth requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -dev -config=/etc/vault-ssh-helper.d/config.hcl\
# HashiConf 2018: ensure pam cleans up successfully\
auth optional pam_unix.so not_set_pass use_first_pass nodelay' /etc/pam.d/sshd

echo "Update sshd configuration"
sed -i '/ChallengeResponseAuthentication no/\
# HashiConf 2018: enable interactive keyboard\
ChallengeResponseAuthentication yes' /etc/ssh/sshd_config
sed -i '/UsePAM no/\
# HashiConf 2018: enable PAM\
UsePAM yes' /etc/ssh/sshd_config

service sshd restart

echo "Create user 'bob'"
useradd -ms /bin/bash bob
usermod -aG sudo bob
