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
               script {
                      sh '''
                           export DOCKER_BUILDKIT=1
                           docker run --name sonarqube -d -p 9000:9000 sonarqube
                           docker build --target sonarscanner .
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
