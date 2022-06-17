#!/bin/bash
wait_seconds=0
echo $1:$2 http://$3:8080/
while [[ $(curl -s -u $1:$2 -w "%{http_code}" http://$3:8080/ -o /dev/null) != "200" ]]; do
   sleep 5
   ((wait_seconds+=5))
   if [[ $wait_seconds  -ge 30  ]]; then
    	echo "Error: no se ha podido iniciar el servidor jenkins después de ${wait_seconds} segundos";
    exit 1;
   fi 
done

#curl -sI -u $1:$2 http://$3:8080/job/tfm-nodejs-app-pipeline/build?token=TFM_CICD 
