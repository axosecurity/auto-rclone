#!/bin/bash

# Function to create the systemd service unit file
create_systemd_service() {
  SERVICE_FILE="/etc/systemd/system/rclone-mount.service"

  cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Rclone Mount Service
Wants=network-online.target
After=network-online.target

[Service]
Type=simple

ExecStart=/usr/bin/rclone mount --allow-other --dir-cache-time 72h --vfs-cache-mode full --vfs-cache-max-age 24h --vfs-cache-max-size 100G --vfs-cache-poll-interval 1m --vfs-read-chunk-size 128M --vfs-read-chunk-size-limit off --poll-interval 10s --buffer-size 32M --fast-list --umask 002 --uid 1000 --gid 1000 --tpslimit 10 --tpslimit-burst 10 --log-level INFO google_drive: /home/axo/test1

Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

  echo "Created systemd service unit file: $SERVICE_FILE"
}

# Function to enable and start the service
enable_start_service() {
  echo "Enabling and starting rclone-mount service..."
  sudo systemctl enable rclone-mount.service
  sudo systemctl start rclone-mount.service
  echo "Done."
}

# Main script
echo "Creating systemd service unit file for rclone mount..."
create_systemd_service
enable_start_service






