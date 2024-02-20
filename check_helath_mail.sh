#!/bin/bash

echo "Enter the Enterprise Console password"
#read -s -p "Password: " pass
echo ""

echo "" > mail.txt

if curl -s http://10.10.240.102:9081/ping | grep -q pong; then
    echo Events services server is: Healthy >> mail.txt
else
    echo Events services server is:Unhealthy >> mail.txt
fi
echo "" >> mail.txt

if curl -s http://10.10.240.102:9081/healthcheck?pretty=true | grep -E -B1 -q ".{0,10}: false{0,10}"; then
    echo Events services connection to Elastic Search is: Unhealthy >> mail.txt
else
    echo Events services connection to Elastic Search is: Healthy >> mail.txt
fi
echo "" >> mail.txt

if curl -s http://10.10.240.103:7001/eumaggregator/ping | grep -q ping; then
    echo EUM server is: Healthy >> mail.txt
else
    echo EUM server is: Unhealthy >> mail.txt
fi
echo "" >> mail.txt

if curl -s -u admin:Admin123 http://10.10.240.101:8090/controller/rest/serverstatus | grep -q true; then
    echo Contorller is: Available >> mail.txt
else
    echo Contorller is: not Available >> mail.txt
fi
echo "" >> mail.txt

if curl --insecure https://10.10.240.101:9191/service/version -s | grep -q version; then
    echo Enterprsie Console is: Available >> mail.txt
else
    echo Enterprsie Console is: not Available >> mail.txt
fi
echo "" >> mail.txt

cat mail.txt | mailx -S smtp=T016-0134.saudivts.com:25 -r notification@saudivts.com -s "AppDynamics Prod-Environment Status" -c mfarhat@saudivts.com -v mmahmoud.c@saudivts.com,nghamdi@saudivts.com,mtshaik@saudivts.com

