
#!/bin/bash
wait_seconds=0

url=http://$3:8080
echo "URL " $1:$2 $url
while [[ $(curl -s -u $1:$2 -w "%{http_code}" $url -o /dev/null) != "200" ]]; do
   sleep 20
   ((wait_seconds+=20))
   if [[ $wait_seconds  -ge 120  ]]; then
      echo "Error: no se ha podido iniciar el servidor jenkins después de ${wait_seconds} segundos";
      exit 1;
   fi 
done


jobname="tfm-nodejs-app-pipeline"
echo "Se ejecuta el pipeline: " $jobname
curl -sI -u $1:$2 "$url/job/$jobname/buildWithParameters?token=TFM_CICD&counter=$4"

sleep 30
wait_seconds=0
while [[ $(curl -s -u $1:$2 $url/job/tfm-nodejs-app-pipeline/lastBuild/api/json  | jq -r '.building') == true ]]; do
   echo "ejecutando el pipeline ${jobname} ..."
   sleep 30
   ((wait_seconds+=30))
   if [[ $wait_seconds  -ge 600  ]]; then
      echo "Error: no se ha finalizado la ejecución del pipeline de ${jobname} en ${wait_seconds} segundos";
      exit 1;
   fi 
done

BUILD_STATUS=$(curl -k -u $1:$2 $url/job/$jobname/lastBuild/api/json | jq -r '.result')
if [[ $BUILD_STATUS == "SUCCESS" ]]; then
   echo "el job ${jobname} se ha ejecutado correctamente."
else 
   echo "el resultado de la ejecución del job ${jobname} es ${BUILD_STATUS}";
   response=$(curl -s -u $1:$2 $url/job/${jobname}/lastBuild/consoleText);
   echo "resultado de la ejeución "$response;
   exit 1;
fi
