FROM minio/minio
COPY ./start-minio.sh /usr/sbin/start-minio.sh
RUN chmod +x /usr/sbin/start-minio.sh
ENTRYPOINT ["/usr/sbin/start-minio.sh"]
