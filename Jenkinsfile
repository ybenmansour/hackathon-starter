pipeline {
   
    environment {
        imagename = "ybenmansour/hackathon-starter"
        dockerImage = ''
        scannerHome = tool 'SonarScanner'
    }
    
    agent any
    
    stages {
        
        stage('Clone repository') {
            steps {
                echo 'Cloning repository'
                git([url: 'https://github.com/ybenmansour/hackathon-starter.git', branch: 'master', credentialsId: 'ybenmansour-github-user-token'])
            }
        }
        
       stage('Unit tests') {
            steps {
               echo 'Unit tests'
               script {
                   sh '''
                     export DOCKER_BUILDKIT=1
                     docker-compose build
                   '''            
               }
            }
       }
       
       stage('Sonar Scanner') {
            steps {
               echo 'Sonar Scanner'
               sh '''
                  docker network create scanner-sq-network
                  docker run -d --rm --network scanner-sq-network --name sonarqube -p 9000:9000 sonarqube
                  sleep 60
               '''
               
               timeout(time: 25, unit: 'SECONDS') {
                  waitUntil {
                     script {
                           final String url = "http://localhost:9000"
                           final String response = sh(script: "curl curl -s -u admin:admin $url/api/system/health | jq -r  '.health'", returnStdout: true).trim()

                           echo response
                     }
                  }
               }
               
               withSonarQubeEnv('SonarQube') {
                  sh "${scannerHome}/bin/sonar-scanner -X"
               }
               
               sh '''
                  sleep 10
               '''
               waitForQualityGate abortPipeline: false
            }
       }
       
       stage('Build') {
            steps {
               echo 'Building docker image'
                script {
                   sh 'export DOCKER_BUILDKIT=1'
                  dockerImage = docker.build imagename
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
