FROM netdata/netdata
# source: https://github.com/netdata/netdata/blob/master/packaging/docker/Dockerfile

RUN apk add --no-cache openssh-server
ENV DOCKER_GRP netdata
ENV DOCKER_USR netdata

ENV NETDATA_PORT 19999

WORKDIR /etc/netdata

COPY ./netdata.conf ./etc/netdata/netdata.conf
COPY ./apps_groups.conf /etc/netdata/apps_groups.conf
COPY ./startup.sh /usr/sbin/startup.sh
RUN chmod +x /usr/sbin/startup.sh

ENTRYPOINT [ "/usr/sbin/startup.sh" ]