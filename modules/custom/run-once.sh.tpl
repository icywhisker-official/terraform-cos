#!/usr/bin/env bash
set -euxo pipefail

# Block device injected by Terraform
DATA_DEVICE="${data_disk}"

# Format if needed
blkid "$DATA_DEVICE" | grep -q ext4 || \
  mkfs.ext4 -L data -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard "$DATA_DEVICE"

# Ensure the Docker network exists
docker network create actual-net || true

# Run each command
%{ for cmd in commands ~}
${cmd}
%{ endfor ~}
