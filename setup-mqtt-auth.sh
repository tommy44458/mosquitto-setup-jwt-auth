#!/bin/bash -i

ROOT=$(dirname $0)

if [ ! -f "/etc/mosquitto/conf.d/go-auth.so" ]; then

    if [ ! -d "$ROOT/mosquitto-go-auth" ]; then
        git clone https://github.com/tommy44458/mosquitto-go-auth.git $ROOT/mosquitto-go-auth
    fi

    if [ ! -f "$ROOT/mosquitto-go-auth/go-auth.so" ]; then
        cd $ROOT/mosquitto-go-auth
        make
        cd -
    fi

    if [ ! -d "/etc/mosquitto/conf.d/" ]; then
        sudo mkdir /etc/mosquitto/conf.d/
    fi

    sudo cp $ROOT/mosquitto-go-auth/go-auth.so /etc/mosquitto/conf.d/
fi

sudo cp $ROOT/mqtt_broker/go-auth.conf /etc/mosquitto/conf.d/

rm -rf $ROOT/mosquitto-go-auth