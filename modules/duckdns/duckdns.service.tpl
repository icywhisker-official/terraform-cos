[Unit]
Description=duckdns reverse proxy
After=network-online.target docker.service

[Service]
User=${user}
WorkingDirectory=${dcdir}
Restart=on-failure
RestartSec=5min
ExecStart=/usr/bin/docker compose --profile duckdns -f ${dcdir}/duckdns-compose.yml up
ExecStop=/usr/bin/docker compose --profile duckdns -f ${dcdir}/duckdns-compose.yml down

[Install]
WantedBy=multi-user.target
