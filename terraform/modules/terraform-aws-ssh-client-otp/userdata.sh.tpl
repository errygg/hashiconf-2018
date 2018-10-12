#!/bin/bash
# User Data script used to setup the target OTP host. This could also be done
# using a configuration management tool such as Chef, Ansible, etc.

#
# Update the packages
#
echo "Update packages and install vault-ssh-helper"
apt-get update
apt-get install -y unzip

#
# Setup the Consul user
#
echo "Setup Consul user"
export GROUP=consul
export USER=consul
export COMMENT=Consul
export HOME=/srv/consul
curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/setup-user.sh | bash

#
# Install and configure Consul
#
echo "Install Consul"
export VERSION=${consul_version}
export URL=${consul_url}
curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/consul/scripts/install-consul.sh | bash

echo "Install Consul Systemd"
curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/consul/scripts/install-consul-systemd.sh | bash

echo "Cleanup install files"
curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/cleanup.sh | bash

echo "Set variables"
CONSUL_CONFIG_FILE=/etc/consul.d/default.json
CONSUL_CONFIG_OVERRIDE_FILE=/etc/consul.d/z-override.json
NODE_NAME=$(hostname)

echo "Update Consul configuration file permissions"
sudo chown consul:consul $CONSUL_CONFIG_FILE

echo "Restart Consul"
sudo systemctl restart consul

#
# Install and configure the vault-ssh-helper
#
mkdir -p /etc/vault-ssh-helper.d
mkdir -p /usr/local/bin
cd /usr/local/bin
wget https://releases.hashicorp.com/vault-ssh-helper/0.1.4/vault-ssh-helper_0.1.4_linux_amd64.zip -O tmp.zip && unzip tmp.zip && rm tmp.zip

echo "Create vault-ssh-helper configuration"
cat << EOF > /etc/vault-ssh-helper.d/config.hcl
vault_addr = "https://vault.erikrygg.com"
ssh_mount_point = "ssh"
tls_skip_verify = false
allowed_roles = "client_otp_dev_role"
EOF

#
# Update the PAM configuration to use the vault-ssh-helper
#
echo "Create PAM sshd configuration"
cat << EOF > /etc/pam.d/sshd
auth requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -config=/etc/vault-ssh-helper.d/config.hcl -dev
auth optional pam_unix.so not_set_pass use_first_pass nodelay
account    required     pam_nologin.so
@include common-account
session [success=ok ignore=ignore module_unknown=ignore default=bad]        pam_selinux.so close
session    required     pam_loginuid.so
session    optional     pam_keyinit.so force revoke
@include common-session
session    optional     pam_motd.so  motd=/run/motd.dynamic noupdate
session    optional     pam_motd.so # [1]
session    optional     pam_mail.so standard noenv # [1]
session    required     pam_limits.so
session    required     pam_env.so # [1]
session    required     pam_env.so user_readenv=1 envfile=/etc/default/locale
session [success=ok ignore=ignore module_unknown=ignore default=bad]        pam_selinux.so open
@include common-password
EOF

echo "Create sshd configuration"
cat << EOF > /etc/ssh/sshd_config
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
UsePrivilegeSeparation yes
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin no
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication no
X11Forwarding no
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
EOF

echo "Create ubuntu user"
useradd -ms /bin/bash ubuntu
usermod -aG sudo ubuntu
