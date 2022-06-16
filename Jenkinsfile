pipeline {
   
    environment {
        imagename = "ybenmansour/hackathon-starter"
        dockerImage = ''
        scannerHome = tool 'SonarScanner'
        sonarQubeURL = "http://localhost:9000/"
    }
    
    agent any
    
    stages {
        
        stage('Clone repository') {
            steps {
                echo 'Cloning repository'
                git([url: 'https://github.com/ybenmansour/hackathon-starter.git', branch: 'master', credentialsId: 'ybenmansour-github-user-token'])
            }
        }
        
        /*stage('Unit tests') {
            steps {
               echo 'Unit tests'
               script {
                    sh 'DOCKER_BUILDKIT=1 docker build --target export-test-results -f Dockerfile.test --output type=local,dest=results .' 
                    archiveArtifacts artifacts: 'results/*.xml'
               }
            }
       }*/
       
       stage('Sonar Scanner') {
            steps {
               echo 'Sonar Scanner'
             
               script {
                    final String response = sh(script: "curl -s -u admin:admin ${sonarQubeURL}api/qualitygates/project_status?projectKey=hackathon-starter | jq '.projectStatus.status' | tr - d", returnStdout: true).trim()
                    echo response
                    if (response != 'OK') {
                       echo "Pipeline aboratdo por fallos de calidad: "+ response
                    } else if (response.equales('OK') {
                       echo "Pipeline contnua por fallos de calidad: "+ response
                    }
                }
            }
       }
       
       stage('Build') {
            steps {
               echo 'Building docker image'
                script {
                  dockerImage = docker.build(imagename, "-f Dockerfile.prod .")
               }
            }
        }
        
       stage('Push image') {
            steps {
               echo 'Pushing docker image'
               script {
                  docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                      dockerImage.push("${env.BUILD_NUMBER}")
                      dockerImage.push("latest")
                  }
               }
            }
        }
       
       stage('Deploy'){
            steps {
                 sh '''
                  kubectl apply -f deployment/deployment-mongo.yml
                  kubectl apply -f deployment/mongo-service.yml
                  kubectl apply -f deployment/deployment-web.yml
                  kubectl apply -f deployment/load-balancer-service.yml
                 '''
            }
        }
       
    }   
    
    post {
        success {
               echo 'Shutdown EC2 istance'
               /*script {
                  sh 'sudo shutdown -h now'
               }*/
        }
        
        failure {
            echo 'Sending email'
            mail to: "youssefbenmansour@gmail.com",
            subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}",
            body: "${currentBuild.currentResult}: ${env.JOB_NAME} Build Number: ${env.BUILD_NUMBER}"
            echo 'Shutdown EC2 istance'
        }
    }
}
