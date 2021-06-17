from balenalib/raspberrypi4-64-debian
COPY start-urbit.sh /usr/sbin/start-urbit.sh 
COPY get-urbit-code.sh /usr/sbin/get-urbit-code.sh
COPY reset-urbit-code.sh /usr/sbin/reset-urbit-code.sh
COPY run-urbit-cmd.sh /usr/sbin/run-urbit-cmd.sh
RUN chmod +x /usr/sbin/start-urbit.sh && chmod +x /usr/sbin/get-urbit-code.sh && chmod +x /usr/sbin/reset-urbit-code.sh && chmod +x /usr/sbin/run-urbit-cmd.sh
WORKDIR /urbit
RUN mkdir piers && mkdir keys
COPY keys/ keys/
COPY piers/ piers/
RUN echo "The Urbit's directory is populated with the following data:" && ls
RUN curl https://s3.us-east-2.amazonaws.com/urbit-on-arm/urbit-on-arm_public.gpg |  apt-key add - && echo 'deb http://urbit-on-arm.s3-website.us-east-2.amazonaws.com buster custom' |  tee /etc/apt/sources.list.d/urbit-on-arm.list && dpkg --add-architecture arm64 && apt update && apt install -y urbit:arm64 rsync  && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/sbin/start-urbit.sh"]

