# mosquitto-setup
Auto install & setup mosquitto broker and ACL policy using JWT auth in a Linux environment.

## Setup mosquitto

#### set broker listen port /mqtt_broker/default.conf
```
listener 1883
protocol mqtt
listener 8083
protocol websockets
```

#### set config of mosquitto /mqtt_broker/mosquitto.conf
```
pid_file /var/run/mosquitto.pid

persistence false
persistence_location /var/lib/mosquitto/

log_dest file /var/log/mosquitto/mosquitto.log

include_dir /etc/mosquitto/conf.d
```

#### set routine policy /mqtt_broker/setup-mqtt-broker.conf
```
# restart broker per 30 min
COMMAND="*/30 * * * * $SOURCE"
```

## Setup JWT acl

#### set acl policy /mqtt_broker/go-auth.conf
```
# database config
auth_opt_jwt_pg_host DB_HOST
auth_opt_jwt_pg_port DB_PORT
auth_opt_jwt_pg_dbname DB_NAME
auth_opt_jwt_pg_user DB_USER
auth_opt_jwt_pg_password DB_POSSWARD

# get username sql
auth_opt_jwt_userquery select count(*) from "user" where username = $1 limit 1
# get admin user sql
auth_opt_jwt_superquery select count(*) from "user" where username = $1
# get acl policy by username
auth_opt_jwt_aclquery select distinct 'application/' || a.id || '/#' from "user" u inner join organization_user ou on ou.user_id = u.id inner join organization o on o.id = ou.organization_id inner join application a on a.organization_id = o.id where u.username = $1 and $2 = $2
# use username field
auth_opt_jwt_userfield username

auth_opt_jwt_parse_token true
# JWT secret key
auth_opt_jwt_secret JWT_SECRET_KEY
```

## Run setup script

```
sudo ./setup-mqtt-broker.sh 
```
