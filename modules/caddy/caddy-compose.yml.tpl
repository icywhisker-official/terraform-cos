services:
  caddy:
    image: caddy:alpine
    container_name: caddy
    restart: unless-stopped
    networks:
      - actual-net
    ports:
      - "443:443"
    volumes:
      - /mnt/disks/data/caddy/Caddyfile:/etc/caddy/Caddyfile:ro
      - /mnt/disks/data/caddy/data:/data
      - /mnt/disks/data/caddy/config:/config
    profiles:
      - caddy

networks:
  actual-net:
    external: true
