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
                /*git([url: 'https://github.com/ybenmansour/hackathon-starter.git', branch: 'master', credentialsId: 'ybenmansour-github-user-token'])*/
            }
        }
        
        stage('Build') {
            steps {
               echo 'Building docker image'
              /* script {
                  dockerImage = docker.build imagename
               }*/
            }
        }
        
        stage('Unit tests') {
            steps {
               echo 'Unit tests '
              /* script {
                  dockerImage.inside {
                     sh 'npm test'
                  }
               }*/
            }
        }
        
        stage('Push image') {
            steps {
               echo 'Pushing docker image'
               /*script {
                  docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                      app.push("${env.BUILD_NUMBER}")
                      app.push("latest")
                  }
               }*/
            }
        }
    }
    
    post {
        success {
               echo 'Shutdown EC2 istance'
               script {
                  sh 'sudo shutdown -P now'
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
