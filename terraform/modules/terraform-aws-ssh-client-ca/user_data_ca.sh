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
# Install and configure the Vault CA
#
echo "\n\nTrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config
echo "${trusted_user_ca}" /tmp/trusted-user-ca-keys.pem /etc/ssh/trusted-user-ca-keys.pem
chmod 600 /etc/ssh/trusted-user-ca-keys.pem
service ssh restart

echo "Create ubuntu user"
useradd -ms /bin/bash ubuntu
usermod -aG sudo ubuntu

${user_data}
