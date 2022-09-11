#!/usr/bin/env bash

ROOT=$(dirname $0)

if [ ! -d "$ROOT/mosquitto-go-auth" ]; then
    git clone https://github.com/iegomez/mosquitto-go-auth.git
fi

if [ ! -f "$ROOT/mosquitto-go-auth/go-auth.so" ]; then
    cd mosquitto-go-auth
    make
    cd ..
fi

sudo cp ./mosquitto-go-auth/go-auth.so /etc/mosquitto/conf.d/
sudo cp ./mqtt_broker/go-auth.conf /etc/mosquitto/conf.d/