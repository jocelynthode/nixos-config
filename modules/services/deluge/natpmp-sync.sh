set -euo pipefail

DELUGE_URL="http://localhost:8112/json"

# Step 1: Login and save cookie jar
COOKIE_JAR=$(mktemp)
curl -s -c "$COOKIE_JAR" -H "Content-Type: application/json" \
  -d '{"method":"auth.login","params":["deluge"],"id":1}' \
  "$DELUGE_URL" | grep -q '"result": true' || {
  echo "Login failed"
  rm -f "$COOKIE_JAR"
  exit 1
}

# Step 2: Run natpmpc commands
OUT_UDP="$(natpmpc -g 10.2.0.1 -a 1 0 udp 60)"
OUT_TCP="$(natpmpc -g 10.2.0.1 -a 1 0 tcp 60)"

REGEX='Mapped public port ([0-9]+) protocol \w{3} to local port [0-9]+ lifetime [0-9]+'

[[ "$OUT_UDP" =~ $REGEX ]] && UDP_PORT="${BASH_REMATCH[1]}" || {
  echo "Failed to parse UDP port"
  rm -f "$COOKIE_JAR"
  exit 1
}
[[ "$OUT_TCP" =~ $REGEX ]] && TCP_PORT="${BASH_REMATCH[1]}" || {
  echo "Failed to parse TCP port"
  rm -f "$COOKIE_JAR"
  exit 1
}

CURRENT_PORTS=$(curl -s -b "$COOKIE_JAR" -H "Content-Type: application/json" \
  -d '{"method":"core.get_config","params":[],"id":2}' \
  "$DELUGE_URL")

OLD_PORTS=$(echo "$CURRENT_PORTS" | grep -Po '"listen_ports"\s*:\s*\[\K[0-9]+,\s*[0-9]+')

echo "Old ports: $OLD_PORTS"

if [[ "$OLD_PORTS" != "$UDP_PORT, $TCP_PORT" ]]; then
  echo "Updating Deluge listen_ports to [$UDP_PORT, $TCP_PORT]"
  curl -s -b "$COOKIE_JAR" -H "Content-Type: application/json" \
    -d '{"method":"core.set_config","params":[{"listen_ports":['"$UDP_PORT"','"$TCP_PORT"']}],"id":3}' \
    "$DELUGE_URL"
else
  echo "Deluge listen_ports already up-to-date"
fi

rm -f "$COOKIE_JAR"
