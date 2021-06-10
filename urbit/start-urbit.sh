#!/bin/bash
set -e
# set defaults
if [ -z "$AMES_PORT" ]; then
    AMES_PORT=34343
fi
# Find the first directory and start urbit with the ship therein
cd /urbit
dirname=$(find . -maxdepth 1 -mindepth 1 -type d | sed -n 1p)
# Check if there is a keyfile, if so boot a ship with its name, and then remove the key
echo "Starting Urbit with Ames port: $AMES_PORT"
if [ -z "$dirname" ]; then
    if [ -e *.key ]; then
        echo "Urbit detected a .key file"
        echo "Urbit will use $keyname.key to create a pier and then restart"
        # Get the name of the key
        keynames="*.key"
        keys=( $keynames )
        keyname=''${keys[0]}
        mv $keyname /tmp
        # Boot urbit with the key, exit when done booting
        urbit -x -t -p $AMES_PORT -w $(basename $keyname .key) -k /tmp/$keyname -c $(basename $keyname .key) 
        # Remove the keyfile for security
        echo "Urbit created a pier from the key $keyname"
        rm /tmp/$keyname
        rm *.key || true
        echo "Urbit will now restart the container"
    else 
        random=$RANDOM
        echo "Urbit did not detect any user selection. Booting a comet with the random name: comet-$random."
        urbit -t -p $AMES_PORT -c comet-$random  
    fi
else
    echo "Urbit detected a Pier named $dirname"
    urbit -t -p $AMES_PORT $(basename $dirname)
fi
