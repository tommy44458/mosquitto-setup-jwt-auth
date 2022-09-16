#!/usr/bin/env bash

ROOT=$(dirname $0)

sudo apt-get install libwebsockets libwebsockets-dev libc-ares2 libc-ares-dev openssl uuid uuid-dev cmake

if [ ! -f "/usr/local/sbin/mosquitto" ]; then
   echo "installing mosquitto"
   wget http://mosquitto.org/files/source/mosquitto-1.6.10.tar.gz -O $ROOT/mosquitto-1.6.10.tar.gz
   tar xzvf $ROOT/mosquitto-1.6.10.tar.gz -C $ROOT

   # use owner config
   sudo cp $ROOT/mqtt_broker/mosquitto/config.mk $ROOT/mosquitto-1.6.10/

   cd $ROOT/mosquitto-1.6.10
   make
   sudo make install
   sudo groupadd mosquitto
   sudo useradd -s /sbin/nologin mosquitto -g mosquitto -d /var/lib/mosquitto
   sudo mkdir -p /var/log/mosquitto/ /var/lib/mosquitto/
   sudo chown -R mosquitto:mosquitto /var/log/mosquitto/
   sudo chown -R mosquitto:mosquitto /var/lib/mosquitto/
   cd -

   rm -rf $ROOT/mosquitto-1.6.10.tar.gz
   rm -rf $ROOT/mosquitto-1.6.10
fi

echo "set config file"
PORT_CONF=$ROOT/mqtt_broker/default.conf
MAIN_CONF=$ROOT/mqtt_broker/mosquitto.conf
SERVICE=$ROOT/mqtt_broker/mosquitto.

if [ ! -d "/etc/mosquitto/" ]; then
   sudo mkdir /etc/mosquitto/
   sudo mkdir /etc/mosquitto/conf.d/
fi

sudo cp $PORT_CONF /etc/mosquitto/conf.d/
sudo cp $MAIN_CONF /etc/mosquitto/
sudo cp $SERVICE /etc/systemd/system/

echo "set restart policy that restart the broker per 30 min"
LIST=`crontab -l`

SOURCE=$ROOT/mqtt_broker/mosquitto_restart.sh
COMMAND="*/30 * * * * $SOURCE"

if echo "$LIST" | grep -q "$SOURCE"; then
   echo "The back job had been added.";

else
   crontab -l | { cat; echo "$COMMAND"; } | crontab -
fi

echo "setup mosquitto auth"
$ROOT/setup-mqtt-auth.sh

sudo systemctl unmask mosquitto service

sudo systemctl enable mosquitto

echo "run mosquitto"
sudo service mosquitto reload
sudo service mosquitto start