#!/usr/bin/env bash
set -euxo pipefail

# Block devices injected by Terraform
SWAP_DEVICE="${swap_disk}"

# Repair / initialize disks
wipefs -a "$SWAP_DEVICE"
mkswap "$SWAP_DEVICE"
swapon "$SWAP_DEVICE"

# Kernel tuning
sysctl vm.swappiness=15

# Create all app directories
%{ for p in paths ~}
mkdir -p "${p}"
%{ endfor ~}
