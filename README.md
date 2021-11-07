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
- Join our [telegram group](https://t.me/homeurbit)

## Project Status & Urbit Grant

The project is under heavy development, as we move away from an MVP and towards an aplpha version of the software.  You can follow the progress of the project via the `projects` tab in this GitHub repository.

## Known issues

- "Public Device URL" offered by balena has a couple of issues. Although we don't have to setup our own DNS, it adds considerable lag to the experience. This is because it adds an extra proxy to the request, as we go through balena's servers. Moreover, either due to incorrect proxying or increased lag, MINIO can't be added to Urbit. As we move forward, the setup will automatically use a proper DNS solution.
- `urbit` is very demanding when it comes to disk speed. **It is advised to use this on a board with an SSD through a SATA or PCI connection**. Aka, a Raspberry pi with an external USB-3 SSD will propably generate lag.
- If you use Raspberry Pi, it doesn't play out of the box with SSD. In order to boot from SSD, please follow the instructions [here](https://forums.balena.io/t/how-to-boot-balenaos-on-an-sSD-why-it-matters-and-how-it-works/341836).

## Deploy with balena

[balena](https://www.balena.io/what-is-balena/) is a complete set of tools for building, deploying and managing fleets of connected linux devices. We opted to use balena because it manages the whole lifecycle of our device and application. We only have to download the OS from our account and load it into the SD card for the Raspberry pi.

balena is completely free for up to 10 devices and most of it's components are Open Source.

The same setup will work flawlessly if you install another OS into the raspberry pi and use `docker-compose up`.


## Getting Started with a new comet

1. Click on the Button above

![](/assets/deploy1.png)

2. Create a balena account (or log in). Create application with default settings.

![](/assets/deploy2.png)

3. To add a device to the application, download the OS image and [flash](https://www.balena.io/etcher/) it to an SD card.

![](/assets/deploy3.png)

4. Insert the SD card to the Rasspberry pi 4, connect it to power + Internet. Wait to download your application.

5. Visit the Cloud Dashboard to see that everything works as expected

![image](https://user-images.githubusercontent.com/13405632/121319220-aafa6e80-c914-11eb-803d-732134d693bd.png)

6. Click on the web terminal, select `urbit` and open a terminal session. Execute `/usr/sbin/get-urbit-code.sh`. This script will give you the code for your Urbit.

7. Visit the following address to access `~Urbit`: `ship.<device_public_url>`. Read more about [balena Public Device URLs](https://www.balena.io/docs/learn/develop/runtime/#public-device-urls).

## Getting Started with a planet/star/galaxy keyfile

1. Add the [device service environment variable](https://www.balena.io/docs/learn/manage/serv-vars/#device-environment-and-service-variables) `KEY_TRANSFER` with a value of `1` to the service `urbit`. This will cause the `urbit` container to restart without starting the `urbit` binary. It will idle.
2. Open the web-terminal in `urbit` container
3. Cd into `keys` directory: `cd /urbit/keys`
4. Open a text editor for a file named after your planet: `nano sipsen-pilser.key`
5. Copy or type your key into the text edit
6. Close the text editor
7. Go back to the service variables and remove the `KEY_TRANSFER` variable (or change it's value to 0).
8. The container will restart, read the key and boot that planet/star/galaxy.

Moreover, if `urbit` has already booted a commet (default behaviour), then you have to add another environment variable called: `PIER_NAME`, equal to the name of your planet (e.g `sipsen-pilser`). This will tell Urbit what pier to boot from, since now there are 2 piers (the new planet and the original commet).

## Getting Started without balena

1. Download an OS system (e.g [Raspberry Pi OS](https://www.raspberrypi.org/software/)). **Make sure it's 64-bit**.
2. Flash the image into an SD card.
3. Get terminal access to the machine (e.g using ssh) and [install docker](https://docs.docker.com/engine/install/debian/).
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

## Environment variables by container

### Urbit

- `$AMES_PORT`: The port for the ames protocol. Default value: `34343`
- `$PIER_NAME`: Name of the pier the user wants to boot from. Useful if there are more than 1 `pier` available.
- `$TRANSFER_KEY`: If set to `1`, the `urbit` container will start but it will **not** start urbit. The container will idle and the user can `ssh` into the container to place their key in `keys` directory. The key should have the form `<name>.key`.

## Netdata

- `$NETDATA_CLAIM_TOKEN`: Claim token for Netdata Cloud
- `$NETDATA_CLAIM_ROOMS`: War-room to add the Netdata Agent
- `$NETDATA_CLAIM_URL`: "https://app.netdata.cloud"
- `$DO_NOT_TRACK`: Set to 1 to disable anonymous product usage statistics for the Netdata agent.

To read more about claiming the Netdata Agent on Netdata Cloud, visit [Netdata Learn](https://learn.netdata.cloud/docs/agent/claim#claim-an-agent-running-in-docker).

### Caddy

- `$DOMAIN`: The default domain name for the device. Default is `<balena_device_uuid>.balena-devices.com`.
- `$PROTOCOL`: What protocol is used to access Home-Urbit. Default is `http`.

### Minio-s3

- `$MINIO_ROOT_USER`: The user for minio authnetication. Default: `home-urbit`
- `$MINIO_ROOT_PASSWORD`: The password for minio authnetication. Default: `home-urbit`

### Relevant documentation

- How to add environment variables with Docker/Docker-compose: [Docker documentation](https://docs.docker.com/compose/environment-variables/)
- How to add environment variables with balena: [balena docs](https://www.balena.io/docs/learn/manage/serv-vars/)

## Accessing the services

Caddy acts as a reverse-proxy. It proxies request based on the `subdomain` of the request.

- `s3.<domain>` will proxy to the MINIO's dashboard
- `s3-api.<domain>` will proxy to the MINIO API
- `ship.<domain>` will proxy to Urbit's dashboard
- `monitor.<domain>` will proxy to Netdata's dashboard

## Helper scripts

These helper scripts are available inside the `urbit` container. To run them, `ssh` into the container either using the `balena` CLI tool or via the web terminal.

- `/usr/sbin/get-urbit-code.sh`: Get your Ship's code. This is required so that you can log into your ship for the first time.
- `/usr/sbin/reset-urbit-code.sh`: Reset your Ship's code.
- **Advanced users:**`/usr/sbin/run-urbit-cmd.sh -a <app> -c <ommand> -s <stdout>`: Run any command on your Urbit.

## Tips

- You can ssh into your device via balena webterminal, balena ssh, and regular ssh. Read more on the [docs](https://www.balena.io/docs/learn/manage/ssh-access/).
- You can tunnel any connection from your local computer to any port on the device, using [balena tunnel](https://www.balena.io/docs/reference/balena-cli/#tunnel-deviceorapplication).
- With docker, we can't automatically set the hostname of the device. Thus, you will need to access it via the IP and not `homeurbit.local`. If you want to [change](https://blog.jongallant.com/2017/11/raspberrypi-change-hostname/) the hostname of your Raspberry Pi.

## License

[MIT License](./LICENSE)

## Contributing

Yes, please.
