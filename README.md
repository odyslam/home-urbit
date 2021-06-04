# Introduction 

Effortlessly install and monitor your last personal server, Urbit.

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

- [ ]  Add minio service to docker-compose.yml for a local S3 replacement
- [ ]  Add support for Deploy with balena 1 click deployment
- [ ]  "Design" workflow to move an existing pier into the container (via Dockerfile?, via rsync?)
- [ ]  Add helpful tips (e.g balena tunnel, ssh keys, etc.)
- [ ]  Write blog post

## Ideas
- [ ]  Add local nginx reverse-proxy with username/password combo for security