![_Home-Urbit](https://user-images.githubusercontent.com/13405632/121785641-98599100-cbc3-11eb-861c-77a95a7db030.png)

# Introduction 

Urbit is a new OS and peer-to-peer network that’s simple by design, built to last forever, and 100% owned by its users.
Urbit OS makes the server side usable for individuals without the need for MEGACORP to run their software. Urbit is your own personal server. 
Urbit is your last computer. Welcome.

[![balena deploy button](https://github.com/OdysLam/home-urbit/blob/master/assets/Deploy%20Urbit%20with%20Balena.svg?raw=true)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/OdysLam/home-urbit)

## Engage

A project by ~sipsen-pilser. 

If you want to chat about this:
- open a GitHub issue
- Join ~middev/the-forge and susbscribe to the project's channel

## Deploy with balena

[balena](https://www.balena.io/what-is-balena/) is a complete set of tools for building, deploying and managing fleets of connected linux devices. We opted to use balena because it manages the whole lifecycle of our device and application. We only have to download the OS from our account and load it into the SD card for the Raspberry pi. 

balena is completely free for up to 10 devices and most of it's components are Open Source. 

The same setup will work flawlessly if you install another OS into the raspberry pi and use `docker-compose up`.

## Available Environment variables by service

### Urbit

- `$AMES_PORT`: The port for the ames protocol. Default value: 34343
- `$PIER_NAME`: If multiple piers are found, choose this pier to boot from.
- `$TRANSFER_KEY`: Idle the container so that I can SSH into it and place my keyfile to boot from.

## Netdata

- `$NETDATA_CLAIM_TOKEN`: Claim token for Netdata Cloud
- `$NETDATA_CLAIM_ROOMS`: War-room to add the Netdata Agent
- `$NETDATA_CLAIM_URL`: "https://app.netdata.cloud"
- `$DO_NOT_TRACK`: Set to 1 to disable anonymous product usage statistics for the Netdata agent.

To read more about claiming the Netdata Agent on Netdata Cloud, visit [Netdata Learn](https://learn.netdata.cloud/docs/agent/claim#claim-an-agent-running-in-docker).

### Nginx

- `$NGINX_USER`: The user for Nginx authentication. Default: home-urbit
- `$NGINX_PASSWORD`: The password for Nginx authentication. Default: home-urbit


### Minio-s3

- `$MINIO_ROOT_USER`: The user for minio authnetication. Default: home-urbit
- `$MINIO_ROOT_PASSWORD`: The password for minio authnetication. Default: home-urbit

### Relevant documentation

- How to add environment variables with Docker/Docker-compose: [Docker documentation](https://docs.docker.com/compose/environment-variables/)
- How to add environment variables with balena: [balena docs](https://www.balena.io/docs/learn/manage/serv-vars/)

## Available scripts

- `/usr/sbin/get-urbit-code.sh`: Get your Ship's code. This is required so that you can log into your ship for the first time.
- `/usr/sbin/reset-urbit-code.sh`: Reset your Ship's code.
- `/usr/sbin/run-urbit-cmd.sh -a <app> -c <ommand> -s <stdout>`: Run any command on your Urbit. For advanced users. You can find the source code for this script [here](https://github.com/OdysLam/home-urbit/blob/master/urbit/run-urbit-cmd.sh)

## Dashboards

- `homeurbit.local/`: Landscape
- `homeurbit.local/minio/`: Minio dashboard -- Local s3 for your urbit
- `homeurbit.local/netdata/`: Netdata dashboard -- Monitor your device and urbit

## Tips

- You can access your ~Home-Urbit, from anywhere using [balena Public Device URLs](https://www.balena.io/docs/learn/develop/runtime/#public-device-urls)
- You can ssh into your device via balena webterminal, balena ssh, and regular ssh. Read more on the [docs](https://www.balena.io/docs/learn/manage/ssh-access/)
- You can tunnel any connection from your local computer to any port on the device, using [balena tunnel](https://www.balena.io/docs/reference/balena-cli/#tunnel-deviceorapplication). This means that you can tunnel port `80` of the device to `localhost:80` and connect to Urbit Landscape from anywhere. (Also possible via using balena Public Device URLs).

## Getting Started with a new comet

1. Click on the Button above

![](/assets/deploy1.png)

2. Create a balena account (or log in). Create application with default settings.

![](/assets/deploy2.png)

3. To add a device to the application, download the OS image and [flash](https://www.balena.io/etcher/) it to an sd card. 

![](/assets/deploy3.png)

4. Insert the sd card to the Rasspberry pi 4, connect it to power + Internet. Wait to download your application. 

5. Visit the Cloud Dashboard to see that everything works as expected

![image](https://user-images.githubusercontent.com/13405632/121319220-aafa6e80-c914-11eb-803d-732134d693bd.png)

6. Click on the web terminal, select `urbit` and open a terminal session. Run script `/usr/sbin/get-urbit-code.sh`. This script will give you the code for your Urbit. 

7. Visit the following address to access `~Landscape`: `http://homeurbit.local`

## Getting Started with a planet/star/galaxy keyfile

1. Run `git clone https://github.com/odyslam/home-urbit` on your computer. 
2. Move the `<private_key_name>.key` file inside the `urbit/keys/` directory of the repo you just download. So `~/home-urbit/urbit/keys/<private_key_name>.key`
3. Create a [balena-cloud account](https://dashboard.balena-cloud.com/apps), then create an application for device type ("Raspberry pi 4"). Let's name it `home-urbit`. 
4. Download [balenacli](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md), install it and [sign into](https://www.balena.io/docs/reference/balena-cli/) your account.
5. `cd` into the repo directory `home-urbit` and run `balena push home-urbit`. 

The reason we can't follow the "Deploy with balena" button flow is that we need to add our key into the application files.

### ALTERNATIVE: Manually add the keyfile inside the urbit container

Balena will build the containers in a remote build server and send the binaries to our device. It means that whatever we add in the docker-compose application (e.g our keys), will live for a brief moment in balena's build servers, something which is not ideal from a security perspective. 

The alternative is to deploy our application with the default settings and manually copy over our keys inside the container.

Define the a [device service environment variable](https://www.balena.io/docs/learn/manage/serv-vars/#device-environment-and-service-variables) , with the following name and value: `TRANSFER_KEY`:`1`. The Urbit container will start, but it will **not** start Urbit. Then you can ssh into the container (either using `balena ssh` or the web terminal) and manually copy over your key into the directory `urbit/keys`. After you do, remove the environment variable we just added. The container will restart and will pick up your key.

## Getting Started with an existing pier

The best option here is to follow the [Alternative](#alternative-manually-add-the-keyfile-inside-the-urbit-container) option above and idle the container. Then, using a command as `scp` or better `rsync`, copy over the pier from your computer into the container. The pier should be placed inside the directory `/urbit/piers/<you_pier_name>`. 

You might find [transfer.sh](https://transfer.sh/) handy. You upload the pier to the service and then download using `curl` from inside `urbit`. 

Another option, is to manually download the source files and follow the flow that is described in [Getting Started with a planet/star/galaxy keyfile](#getting-started-with-a-planetstargalaxy-keyfile). Instead of placing the keyfile, you will place your `<your_pier_name>` inside the `/home-urbit/urbit/piers` directory, thus: `/home-urbit/urbit/piers/<your_pier_name>`.


## Getting Started without balena

1. Download an OS system (e.g [Raspberry Pi OS](https://www.raspberrypi.org/software/)). **Make sure it's 64-bit**.
2. Flash the image into an sd card.
3. Get terminal access to the machine (e.g using ssh) and [install docker](https://docs.docker.com/engine/install/debian/).
4. Install `git` , run `sudo apt-get install git`
5. Download this repository, run `git clone https://github.com/odyslam/home-urbit`
6. `cd` into the repository
7. run `sudo docker-compose up`
8. After you seee output from the Urbit container that references `localhost`, open a second terminal window.
9. In the second window, run `sudo docker ps` to find the `ID` of the container that runs `urbit`. 
10. Run `sudo docker exec -it /bin/bash/ <container_ID`. You will get a new terminal inside the container.
11. Run `/usr/sbin/get-urbit-code.sh`. You should see a code on the terminal. That's the password for your ship. Note it down.
12. Type `exit` to exit the shell. 
13. visit `<raspberrypi_IP>` from a browser and enter the code you noted. 
14. Celebrate 🍾


**Note**: With docker, we can't automatically set the hostname of the device. Thus, you will need to access it via the IP and not `homeurbit.local`.

If you want to [change](https://blog.jongallant.com/2017/11/raspberrypi-change-hostname/) the hostname of your Raspberry Pi. You will be able to access the device via `<hostname>.local`.

## Configure minio S3 storage

![](/assets/minio.gif)

1. Visit Landscape System Preferences
2. Go to remote storage
3. Add `minio-s3:9000` as the endpoint
4. Add username/password (default are `home-urbit`/`home-urbit`)
5. 🤙

## Monitoring with Netdata

### Urbit's container metrics
![image](https://user-images.githubusercontent.com/13405632/122733584-fce0b400-d285-11eb-811c-e42cffde2a40.png)

### Urbit's process metrics
![image](https://user-images.githubusercontent.com/13405632/122733708-17b32880-d286-11eb-90d3-4d73c70bac16.png)


## Standing on the shoulders of giants

- [netdata/netdata](https://github.com/netdata/netdata)
- [balena](https://balena.io)
- [minio](https://min.io/)
- Urbit on Raspberry pi:
    - [Urbit grant](https://grants.urbit.org/proposals/337545546-urbian-a-customized-linux-distribution-for-urbit-appliances?tab=milestones) 
    - [Homepage](https://botter-nidnul.github.io/AArch64_Urbit_Static_Binaries.html)
- Tlon's Urbit docker image:
    - [dockerhub](https://hub.docker.com/r/tloncorp/urbit)
    - [Dockerfile](https://github.com/urbit/urbit/blob/master/nix/pkgs/docker-image/default.nix)

## TODO

- [x]  Add minio service to docker-compose.yml for a local S3 replacement
- [x]  Add support for Deploy with balena 1 click deployment
- [x]  "Design" workflow to move an existing pier into the container
- [x]  Add local nginx with username/password combo for netdata security
- [x]  Add logic to automatically detect PGID and docker/balena socket in Netdata
- [x]  Add instructions for setting up keys/planets and copying an existing pier
- [x]  PR this repo to awesome-urbit
- [x]  Add helpful tips (e.g balena tunnel, ssh keys, etc.)
- [x]  Add a script to send arbitrary command to dojo (`/usr/sbin/send-urbit-command.sh <command>`)
- [x]  Submit [grant proposal](https://github.com/urbit/urbit.org/pull/1110)

## License

[MIT License](./LICENSE)

## Contributing

Yes, please.
