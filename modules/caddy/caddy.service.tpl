[Unit]
Description=Caddy Proxy
After=network-online.target docker.service

[Service]
User=${user}
WorkingDirectory=${dcdir}
Restart=on-failure
RestartSec=5min
ExecStart=/usr/bin/docker compose --profile caddy -f ${dcdir}/caddy-compose.yml up
ExecStop=/usr/bin/docker compose --profile caddy -f ${dcdir}/caddy-compose.yml down

[Install]
WantedBy=multi-user.target
