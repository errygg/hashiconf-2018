#!/bin/bash
# User Data script used to setup the target CA host. This could also be done
# using a configuration management tool such as Chef, Ansible, etc.

echo "Update packages and install vault-ssh-helper"
apt-get update
apt-get install -y unzip

echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config
curl -o /etc/ssh/trusted-user-ca-keys.pem ${vault_addr}/v1/${namespace}/ssh/public_key
chmod 600 /etc/ssh/trusted-user-ca-keys.pem
service sshd restart

echo "Create user 'suzy'"
useradd -ms /bin/bash suzy
usermod -aG sudo suzy
