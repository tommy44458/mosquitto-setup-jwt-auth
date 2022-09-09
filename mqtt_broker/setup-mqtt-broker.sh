#!/usr/bin/env bash

ROOT=$(dirname $0)

echo "installing mosquitto"
sudo apt-get install mosquitto mosquitto-clients


echo "set config file"
PORT_CONF=$ROOT/default.conf
MAIN_CONF=$ROOT/mosquitto.conf
sudo cp $PORT_CONF /etc/mosquitto/conf.d/
sudo cp $MAIN_CONF /etc/mosquitto/

echo "set restart policy that restart the broker per 30 min"
LIST=`crontab -l`

SOURCE=$ROOT/mosquitto_restart.sh
COMMAND="*/30 * * * * $SOURCE"

if echo "$LIST" | grep -q "$SOURCE"; then
   echo "The back job had been added.";

else
   crontab -l | { cat; echo "$COMMAND"; } | crontab -
fi

sudo systemctl enable mosquitto

echo "run mosquitto"
sudo service mosquitto reload
sudo service mosquitto start