# mosquitto_setup
Auto install &amp; setup mosquitto broker in a Linux environment.

## set broker listen port /mqtt_broker/default.conf
```
listener 1883
protocol mqtt
listener 8083
protocol websockets
```

## set config of mosquitto /mqtt_broker/mosquitto.conf
```
pid_file /var/run/mosquitto.pid

persistence false
persistence_location /var/lib/mosquitto/

log_dest file /var/log/mosquitto/mosquitto.log

include_dir /etc/mosquitto/conf.d
```

## set routine policy /mqtt_broker/setup-mqtt-broker.conf
```
# restart broker per 30 min
COMMAND="*/30 * * * * $SOURCE"
```

## run setup script

```
sudo ./mqtt_broker/setup-mqtt-broker.sh 
```
