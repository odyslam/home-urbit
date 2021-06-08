FROM arm64v8/nginx
RUN apt-get update && apt-get install -y nano apache2-utils
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./start-nginx.sh /usr/sbin/start-nginx.sh
RUN chmod +x /usr/sbin/start-nginx.sh
RUN mkdir /logs
ENTRYPOINT ["/usr/sbin/start-nginx.sh"]
