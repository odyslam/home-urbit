# Introduction 

Effortlessly install and monitor your last personal server, Urbit.

[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/OdysLam/home-urbit.git)

## Standing on the shoulders of giants

- [netdata/netdata](https://github.com/netdata/netdata)
- [balena](https://balena.io)
- Urbit on Raspberry pi:
    - [Urbit grant](https://grants.urbit.org/proposals/337545546-urbian-a-customized-linux-distribution-for-urbit-appliances?tab=milestones) 
    - [Homepage](https://botter-nidnul.github.io/AArch64_Urbit_Static_Binaries.html)
- Tlon's Urbit docker image:
    - [dockerhub](https://hub.docker.com/r/tloncorp/urbit)
    - [Dockerfile](https://github.com/urbit/urbit/blob/master/nix/pkgs/docker-image/default.nix)

## TODO

- [x]  Add minio service to docker-compose.yml for a local S3 replacement
- [ ]  Add support for Deploy with balena 1 click deployment
- [x]  "Design" workflow to move an existing pier into the container (via Dockerfile?, via rsync?)
- [ ]  Add helpful tips (e.g balena tunnel, ssh keys, etc.)
- [ ]  Write blog post

## Ideas
- [x]  Add local nginx reverse-proxy with username/password combo for security
