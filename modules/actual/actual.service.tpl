[Unit]
Description=Actual Server Finance Tracker
After=network-online.target docker.service

[Service]
User=${user}
WorkingDirectory=${dcdir}
Restart=on-failure
RestartSec=5min
ExecStart=/usr/bin/docker compose --profile actual -f ${dcdir}/actual-compose.yml up
ExecStop=/usr/bin/docker compose --profile actual -f ${dcdir}/actual-compose.yml down

[Install]
WantedBy=multi-user.target
