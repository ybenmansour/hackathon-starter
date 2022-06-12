pipeline {
   
    environment {
        imagename = "ybenmansour/hackathon-starter"
        dockerImage = ''
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
                     sh 'docker-compose build'            
               }
            }
        }
       
        stage('Sonar scanner') {
            steps {
               echo 'Sonar scanner'
               script {
                     sh '''docker create --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
                           npm install sonarqube-scanner --save-dev
                           npm run sonar
                     '''            
               }
            }
        }
        
        stage('Build') {
            steps {
               echo 'Building docker image'
                script {
                  dockerImage = docker.build imagename
               }
            }
        }
        

       stage('Push image') {
            steps {
               echo 'Pushing docker image'
               script {
                  docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                      app.push("${env.BUILD_NUMBER}")
                      app.push("latest")
                  }
               }
            }
        }
    }
    
    post {
        success {
               echo 'Shutdown EC2 istance'
               script {
                  sh 'sudo shutdown -h now'
               }
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
