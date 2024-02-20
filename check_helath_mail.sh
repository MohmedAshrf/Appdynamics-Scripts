#!/bin/bash

#clean the text file
echo "" > mail.txt 

#check the Events service health
if curl -s http://<ES IP>:9081/ping | grep -q pong; then
    echo Events services server is: Healthy >> mail.txt
else
    echo Events services server is: Unhealthy >> mail.txt
fi
echo "" >> mail.txt

#check the Events service Elastic search health
if curl -s http://<ES IP>:9081/healthcheck?pretty=true | grep -E -B1 -q ".{0,10}: false{0,10}"; then
    echo Events services connection to Elastic Search is: Unhealthy >> mail.txt
else
    echo Events services connection to Elastic Search is: Healthy >> mail.txt
fi
echo "" >> mail.txt

#check the EUM health
if curl -s http://<EUM IP>:7001/eumaggregator/ping | grep -q ping; then
    echo EUM server is: Healthy >> mail.txt
else
    echo EUM server is: Unhealthy >> mail.txt
fi
echo "" >> mail.txt

#check the controller health
if curl -s -u <admin username>:<admin password> http://<Controller IP>:8090/controller/rest/serverstatus | grep -q true; then
    echo Controller is: Available >> mail.txt
else
    echo Controller is: not Available >> mail.txt
fi
echo "" >> mail.txt

#check the Enterprise console health
if curl --insecure https://<EC IP>:9191/service/version -s | grep -q version; then
    echo Enterprise Console is: Available >> mail.txt
else
    echo Enterprise Console is: not Available >> mail.txt
fi
echo "" >> mail.txt

#send an email with the status
cat mail.txt | mailx -S smtp=<SMTP host>:<port> -r <Sender email> -s <Subject> -c <CC email> -v <To email>

