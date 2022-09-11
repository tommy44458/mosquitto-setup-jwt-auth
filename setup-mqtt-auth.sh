#!/usr/bin/env bash

ROOT=$(dirname $0)

if [ ! -f "$ROOT/mqtt_broker/mosquitto-go-auth/go-auth.so" ]; then
    cd mosquitto-go-auth
    make
    cd ..
fi

sudo cp ./mqtt_broker/mosquitto-go-auth/go-auth.so /etc/mosquitto/conf.d/
sudo cp ./mqtt_broker/go-auth.conf /etc/mosquitto/conf.d/