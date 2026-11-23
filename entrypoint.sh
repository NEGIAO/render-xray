#!/bin/bash
set -e
if [ -z "$PORT" ] || [ -z "$UUID" ] || [ -z "$WS_PATH" ]; then
  echo "Missing required env vars: PORT, UUID, WS_PATH" >&2
  exit 1
fi
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "info" },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "$UUID", "level": 0 }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WS_PATH" }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "settings": {} }
  ]
}
EOF
echo "Starting Xray: VLESS+WS on port $PORT, path $WS_PATH"
exec /usr/bin/xray -config /etc/xray/config.json
