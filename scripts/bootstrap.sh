#!/bin/bash
apt update && apt upgrade -y
curl -fsSL https://get.docker.com | sh
usermod -aG docker azureuser
apt install docker-compose-plugin -y
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 3000/tcp
ufw allow 9090/tcp
ufw allow 9100/tcp
ufw reload
