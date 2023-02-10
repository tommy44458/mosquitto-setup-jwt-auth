#!/bin/bash -i

ROOT=$(dirname $0)

if [ -f "/etc/mosquitto/conf.d/go-auth.so" ]; then
    sudo rm -rf /etc/mosquitto/conf.d/go-auth.so
fi

if [ ! -d "$ROOT/mosquitto-go-auth" ]; then
    git clone https://github.com/tommy44458/mosquitto-go-auth.git $ROOT/mosquitto-go-auth
fi

cd $ROOT/mosquitto-go-auth
make
cd -

if [ ! -d "/etc/mosquitto/conf.d/" ]; then
    sudo mkdir /etc/mosquitto/conf.d/
fi

sudo cp $ROOT/mosquitto-go-auth/go-auth.so /etc/mosquitto/conf.d/

sudo cp $ROOT/mqtt_broker/go-auth.conf /etc/mosquitto/conf.d/

rm -rf $ROOT/mosquitto-go-auth