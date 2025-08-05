services:
  duckdns:
    image: lscr.io/linuxserver/duckdns:latest
    container_name: duckdns
    restart: unless-stopped
    environment:
     SUBDOMAINS: "${duckdns_domain}"
     TOKEN: "${duckdns_token}"
    profiles:
      - duckdns
