FROM traefik:2.5.3
RUN apt-get update && apt-get install -y nano apache2-utils && mkdir /etc/traefik /logs
COPY ./traefik.yml /etc/traefik/traefik.yml
COPY ./start-nginx.sh /usr/sbin/start-nginx.sh
RUN chmod +x /usr/sbin/start-trefik.sh
ENTRYPOINT ["/usr/sbin/startlat-nginx.sh"]
