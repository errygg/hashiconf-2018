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
# Install and configure the Vault CA
#
echo "\n\nTrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config
echo "${trusted_user_ca}" /tmp/trusted-user-ca-keys.pem /etc/ssh/trusted-user-ca-keys.pem
chmod 600 /etc/ssh/trusted-user-ca-keys.pem
service ssh restart

echo "Create ubuntu user"
useradd -ms /bin/bash ubuntu
usermod -aG sudo ubuntu
