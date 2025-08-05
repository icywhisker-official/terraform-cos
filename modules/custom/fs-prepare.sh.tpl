#!/bin/bash
set -eux
if ! id "${user}" &>/dev/null; then
  useradd "${user}"
  usermod -aG docker "${user}"
fi
PLUGINS_DIR="/var/lib/google"
DOCKER_CONFIG="/home/${user}/.docker"
CLI_PLUGINS="$${DOCKER_CONFIG}/cli-plugins"
mkdir -p "$${PLUGINS_DIR}" "$${CLI_PLUGINS}"
curl -SL "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-$(uname -m)" \
    -o "$${PLUGINS_DIR}/docker-compose"
chmod +x "$${PLUGINS_DIR}/docker-compose"
ln -sf "$${PLUGINS_DIR}/docker-compose" "$${CLI_PLUGINS}/docker-compose"
touch "$${DOCKER_CONFIG}/config.json"
chmod 600 "$${DOCKER_CONFIG}/config.json"
chown -R "${user}:${user}" "$${DOCKER_CONFIG}" "$${PLUGINS_DIR}"
