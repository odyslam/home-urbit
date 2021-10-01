#!/bin/bash
if [[ $BALENA_ARCH == "aarch64" ]]; then
  curl https://s3.us-east-2.amazonaws.com/urbit-on-arm/urbit-on-arm_public.gpg | apt-key add -
  echo 'deb http://urbit-on-arm.s3-website.us-east-2.amazonaws.com buster custom' | tee /etc/apt/sources.list.d/urbit-on-arm.list
  dpkg --add-architecture arm64
  apt update
  apt install -y urbit:arm64 rsync
  rm -rf /var/lib/apt/lists/*
elif [[ $BALENA_ARCH == "amd64" ]]; then
  mkdir binary && cd binary
  wget --content-disposition https://urbit.org/install/linux64/latest
  tar zxvf ./linux64.tgz --strip=1
fi
