services:
  actual_server:
    image: actualbudget/actual-server:latest
    container_name: actual
    restart: unless-stopped
    networks:
      - actual-net
    ports:
      - "5006:5006"
    volumes:
      - ${datadir}:/data
    profiles:
      - actual
networks:
  actual-net:
    external: true
