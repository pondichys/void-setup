#!/usr/bin/env bash
# Script that defines some utility functions
set -euo pipefail

# Check if a service exists
# Returns 0 if it exists, 1 if not
check_svc() {
  local service_name="$1"
  local sv_dir="/etc/sv/${service_name}"
  local sv_link="/var/service/${service_name}"

  # Check if service definition exists
  if [ -d "sv_dir" ] && [ -f "$sv_dir/run" ]; then
    echo "Service definition '$service_name' found in '$sv_dir'."
    return 0
  else
    echo "Service definition '$service_name' not found in '$sv_dir'."
    return 1
  fi
}

enable_svc() {
  local service_name="$1"
  local sv_dir="/etc/sv/${service_name}"
  local sv_link="/var/service/${service_name}"
  
  if [ -L "$sv_link" ] && [ "$(readlink "$sv_link")" = "$sv_dir" ]; then
    echo "Service '$service_name' is already enabled.\n Nothing to do."
    return 0
  else
    echo "Service '$service_name' is NOT enabled. Enabling it now ..."
    sudo ln -s "sv_dir" "sv_link" || { echo "Could not enable service. Check permissions."; return 1; }
    echo "Service '$service_name' enabled."
  fi
  return 0
}

