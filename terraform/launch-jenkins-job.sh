#!/bin/bash
wait_seconds=0
while [[ $(curl -s -u $2:$3 -w "%{http_code}" http://$1:8080/ -o /dev/null) != "200" ]]; do
   sleep 5
   ((wait_seconds+=5))
   if [[ $wait_seconds  -ge 30  ]]; then
    	echo "Error: no se ha podido iniciar el servidor jenkins después de ${wait_seconds} segundos";
    exit 1;
   fi 
done

#curl -sI -u $2:$3 http://$1:8080/job/tfm-nodejs-app-pipeline/build?token=TFM_CICD 
