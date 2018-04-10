#!/bin/bash
docker run -d --name ca-client --network vault-net -p 2222:22 rastasheep/ubuntu-sshd

