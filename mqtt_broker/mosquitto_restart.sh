if [ "`ps -aux | grep /usr/sbin/mosquitto | wc -l`" == "1" ] then
    sudo service mosquitto restart
    exit 0
fi

exit 0
