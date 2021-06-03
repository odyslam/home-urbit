#!/bin/bash
echo "Requesting Urbit code from http://127.0.0.1:12321"
echo 
raw=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{ "source": { "dojo": "+code" }, "sink": { "stdout": null } }' \
    http://127.0.0.1:12321)
# trim \n" from the end
if [ -z "$raw" ]; then
    echo "POST request to 'http://127.0.0.1:12321' returned an empty string"
    echo "Make sure that Urbit is running and has finished setup"
    echo "Urbit will output the following lines when it finishes:" 
    echo "-----"
    echo "http: web interface live on http://localhost:80"
    echo "http: loopback live on http://localhost:12321"
    echo "pier (50372): live"
    echo "-----"
    echo "Run the command again when Urbit is up and running"
    echo 
else
    trim="${raw%\\n\"}"
    # trim " from the start
    code="${trim#\"}"
    echo "dojo '+code' output"
    echo "$code"
fi