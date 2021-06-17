#!/bin/bash
while getopts 's:a:c:' flag;
do
    case "${flag}" in
        c) command="${OPTARG}";;
        a) app="${OPTARG}";;
        s) stdout="${OPTARG}";;
    esac
done
echo "Sending command to local Urbit with the following parameters"
echo "Application: $app, Command: $command, stdout: $stdout"
echo
raw=$(curl -s -X POST -H "Content-Type: application/json" \
    -d "{ \"source\": { \"${app}\": \"${command}\" }, \"sink\": { \"stdout\": ${stdout} } }" \
    http://127.0.0.1:12321)
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
    output="${trim#\"}"
    echo "Urbit returned the following output:"
    echo "$output"
fi