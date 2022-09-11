# mosquitto-setup-jwt-auth
Auto install & setup mosquitto broker and ACL policy using JWT auth in a Linux environment.

## Requirements
This package uses `Go modules` to manage dependencies. As it interacts with `mosquitto`, it makes use of `cgo`.

Only Linux (tested in Debian, Ubuntu and Mint ùs) and MacOS are supported.

Before attempting to build the plugin, make sure you have go installed on the system.
The minimum required GO version for the current release is 1.13.8.
To check which version (if any) of Go is installed on the system, simply run the following:

```
go version
```

If Go is not installed or the installed version is older than 1.13.8, please update it.
You can retrieve and install the latest version of Go from the official [Go download website](https://golang.org/dl/):

```
# Update the following as per your system configuration
export GO_VERSION=1.16.4
export GO_OS=linux
export GO_ARCH=amd64

wget https://dl.google.com/go/go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz -O golang.tar.gz
sudo tar -C /usr/local -xzf golang.tar.gz
export PATH=$PATH:/usr/local/go/bin
rm golang.tar.gz

# Prints the Go version
go version
```

## Setup mosquitto

#### Set broker listen port /mqtt_broker/default.conf
```
listener 1883
protocol mqtt
listener 8083
protocol websockets
```

#### Set config of mosquitto /mqtt_broker/mosquitto.conf
```
pid_file /var/run/mosquitto.pid

persistence false
persistence_location /var/lib/mosquitto/

log_dest file /var/log/mosquitto/mosquitto.log

include_dir /etc/mosquitto/conf.d
```

#### Set routine policy /mqtt_broker/setup-mqtt-broker.conf
```
# restart broker per 30 min
COMMAND="*/30 * * * * $SOURCE"
```

## Setup JWT ACL

#### Set ACL policy /mqtt_broker/go-auth.conf
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
