#!/usr/bin/env bash
set -e

CONFIG_PATH="$(dirname $0)/pushover.cfg"
ESSID=$1
IFACE=$2

# Create Service File for Linux
SERVICE_FILE='deauth_detect.service'

cat > ${SERVICE_FILE} <<EOF
[Unit]
Description=Deauth Detector Service

[Service]
ExecStart=/usr/bin/python3 $(dirname $0)/deauth_detector.py $IFACE $ESSID $CONFIG_PATH
Restart=always
User=root
Group=root
Environment=PATH=/usr/bin:/usr/local/bin
Environment=PYTHONUNBUFFERED=1
StandardOutput=file:/var/log/deauth_detector.log
StandardError=file:/var/log/deauth_detector.err.log

[Install]
WantedBy=multi-user.target
EOF

sudo cp ${SERVICE_FILE} /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start deauth_detect.service

