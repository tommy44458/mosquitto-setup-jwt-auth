if [ "`ps -aux | grep /usr/sbin/mosquitto | wc -l`" == "1" ] then
    systemctl restart mosquitto
    exit 0
fi

exit 0
