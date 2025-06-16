#!/usr/bin/env bash
set -euo pipefail

host=""
ip=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      host="$2"
      shift 2
      ;;
    --ip)
      ip="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 --host <hostname> --ip <ip-address>"
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$host" || -z "$ip" ]]; then
  echo "Error: --host and --ip are required" >&2
  echo "Usage: $0 --host <hostname> --ip <ip-address>" >&2
  exit 1
fi

temp=$(mktemp -d)

cleanup() {
  rm -rf "$temp"
}
trap cleanup EXIT

install -d -m755 "$temp/persist/etc/ssh"

ssh-keygen -q -t rsa -b 4096 -C "hostname" -N "" -f "$temp/persist/etc/ssh/ssh_host_rsa_key"
ssh-keygen -t ed25519 -C "hostname" -N "" -f "$temp/persist/etc/ssh/ssh_host_ed25519_key"

ssh-to-age -i "$temp/persist/etc/ssh/ssh_host_ed25519_key.pub" -o /tmp/age.txt

nvim .sops.yaml /tmp/age.txt

sops updatekeys ./secrets/**/*.yaml

git commit -am'Update sops keys' && git push

nixos-anywhere --extra-files "$temp" --flake ".#${host}" -p 2222 --target-host "root@${ip}"
