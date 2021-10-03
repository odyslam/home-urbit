#!/bin/bash
set -e
# set defaults
if [ -z "$AMES_PORT" ]; then
    AMES_PORT=34343
    export AMES_PORT
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Starting Urbit with Ames port: $AMES_PORT"
DEVICE_ARCH=$(uname -m)
if [[ $DEVICE_ARCH == "aarch64" ]]; then
    echo "Urbit binary:  $(which urbit)"
elif [[ $DEVICE_ARCH == "x86_64" ]]; then
  export PATH="$PATH:/urbit/binary"
  echo "Urbit binary: $(which urbit)"
fi

# Make a call to the balena supervisor to set hostname to homeurbit.
# This makes the device accessible as `homeurbit.local`
# Read more about the API: https://www.balena.io/docs/reference/supervisor/supervisor-api/

curl -f -s -X PATCH --header "Content-Type:application/json" \
    --data '{"network": {"hostname": "homeurbit"}}' \
    "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY" \
    && echo && echo "Urbit set hostname to 'homeurbit'. You can access the device by typing homeurbit.local on your browser" \
    || echo "Urbit failed to set the hostname of the device. If you are not using balena, this is normal."

cd /urbit
dirs=$(find ./piers/ -maxdepth 1 -mindepth 1 -type d)
dirNumber=$(echo "$dirs" | grep -c "^")
dirname=$(echo "$dirs" | sed -n 1p)
# Check if there is a keyfile, if so boot a ship with its name, and then remove the key

if [ "$TRANSFER_KEY" == "1" ];then
    echo "Detected TRANSFER_KEY=1"
    echo "Urbit will now idle."
    echo "Download your ship's keyfile (keyfile.key) and place it inside the directory /urbit/keys of the Urbit container"
    echo "Remove the environment variable and restart the container."
    tail -f /dev/null
fi

# Priority list:
# 1) Keyfile exist
# 2) Piers exist
#   a) If only 1 pier exists, boot that
#   b) If multiple piers exist, ask user to either define an env_varible and restart the container
#      or delete the other piers until there is only one
#      To add a service variable, visit https://www.balena.io/docs/learn/manage/serv-vars/
#      Urbit expects variable named: PIER_NAME
# 3) Boot new comet with random name

if [ -e keys/*.key ]; then
        # Get the name of the key
        keyname=$(find ./keys -type f -name "*.key")
        # Boot urbit with the key, exit when done booting
        echo "Urbit detected a .key file"
        echo "Urbit will use $keyname to create a pier and then restart. Please wait while it initializes your ship."
        urbit -x -p $AMES_PORT -w $(basename $keyname .key) -k $keyname -c piers/$(basename $keyname .key) || echo "Urbit can't initialize a pier with the key $keyname" \
        && echo "It's possible that there is already an initialized pier with that keyfile." && echo "Urbit will now delete the keyfile and reboot."
        # Remove the keyfile for security
        echo "Urbit will delete the key for security reasons."
        rm "$keyname"
        echo "Urbit will now restart the container."
elif [ -z "$dirname" ]; then
    random=$RANDOM
    echo "Urbit did not detect any user selection. Booting a comet with the random name: comet-$random."
    urbit -t -p $AMES_PORT -c piers/comet-$random
else
    if [ $dirNumber == "1" ];then
        echo "Urbit detected a Pier named $dirname"
        urbit -t -p $AMES_PORT piers/$(basename $dirname)
    else
        if [ -z "$PIER_NAME" ]; then
            echo "Urbit detected multiple Piers. They have the following names:"
            echo "$dirs"
            echo "Urbit also did not detect a user's choice for which pier to boot."
            echo "Urbit will now stay idle. You have 2 options:"
            echo "1) SSH into the Urbit container and delete the other piers."
            echo "2) Add a 'device service variable' named 'PIER_NAME' with the name of the pier that you wish to boot."
            echo "You should add the service variable to the service named: urbit"
            echo "If you use balena, you can ssh with balena dashboard or balena ssh"
            echo "If you use docker, run 'docker exec -it /bin/bash <container_ID>'"
            echo "If you add the variable, it will restart automatically. If you ssh, please restart the container."
            echo "Urbit is now idling.."
            tail -f /dev/null
        else
            echo "Urbit detected multiple piers. Urbit also detected the env variable PIER_NAME: $PIER_NAME"
            urbit -t -p $AMES_PORT piers/$PIER_NAME
        fi
    fi
fi
