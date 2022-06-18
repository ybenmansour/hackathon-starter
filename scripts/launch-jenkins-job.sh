
#!/bin/bash
wait_seconds=0

ip=$3
echo "URL " $1:$2 http://$ip:8080/

while [[ $(curl -s -u $1:$2 -w "%{http_code}" http://$ip:8080/ -o /dev/null) != "200" ]]; do
   sleep 5
   ((wait_seconds+=5))
   echo $wait_seconds
   if [[ $wait_seconds  -ge 30  ]]; then
      echo "Error: no se ha podido iniciar el servidor jenkins después de ${wait_seconds} segundos";
      exit 1;
   fi 
done

jobname="tfm-nodejs-app-pipeline"
echo "Se ejecuta el pipeline: " $jobname
curl -sI -u $1:$2 http://$ip:8080/job/$jobname/build?token=TFM_CICD 

while [[ $(curl -s -u $1:$2 http://$ip:8080/job/tfm-nodejs-app-pipeline/lastBuild/api/json  | jq -r '.building') == true ]]; do
   sleep 30
done

BUILD_STATUS=$(curl -k -u $1:$2 --silent http://$ip:8080/job/$jobname/lastBuild/api/json | jq -r '.result')
if [[ $BUILD_STATUS == "SUCCESS" ]]; then
   echo "el job ${jobname} se ha ejecutado correctamente."
else 
   echo "el resultado de la ejecución del job ${jobname} es ${BUILD_STATUS}"
   echo "http://$ip:8080/job/${jobname}/lastBuild/consoleText"  >> $GITHUB_STEP_SUMMARY
fi
