FROM debian:latest
COPY start-urbit.sh /usr/sbin/start-urbit.sh
COPY get-urbit-code.sh /usr/sbin/get-urbit-code.sh
COPY reset-urbit-code.sh /usr/sbin/reset-urbit-code.sh
COPY run-urbit-cmd.sh /usr/sbin/run-urbit-cmd.sh
RUN apt-get update && apt-get --no-install-recommends install -y curl wget vim ca-certificates gnupg
RUN chmod +x /usr/sbin/start-urbit.sh && chmod +x /usr/sbin/get-urbit-code.sh && chmod +x /usr/sbin/reset-urbit-code.sh && chmod +x /usr/sbin/run-urbit-cmd.sh
WORKDIR /urbit
RUN mkdir piers && mkdir keys
COPY keys/ keys/
COPY piers/ piers/
COPY install-urbit.sh /tmp/install-urbit.sh
RUN echo "The Urbit's directory is populated with the following data:" && ls
RUN  chmod +x /tmp/install-urbit.sh && /tmp/install-urbit.sh && rm /tmp/install-urbit.sh
ENTRYPOINT ["/usr/sbin/start-urbit.sh"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]
