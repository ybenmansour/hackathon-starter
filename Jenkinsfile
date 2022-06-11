pipeline {
    agent any
    
    environment {
        imagename = "ybenmansour/hackathon-starter"
    }
    
    stages {
        stage('Clone repository') {
            steps {
                echo 'Cloning repository'
                git([url: 'https://github.com/ybenmansour/hackathon-starter.git', branch: 'master', credentialsId: 'ybenmansour-github-user-token'])
            }
        }
        stage('Build') {
            steps {
               echo 'Building docker image'
               app = docker.build("ybenmansour/hackathon-starter")
            }
        }
        stage('Unit tests') {
            echo 'Unit tests '
            app.inside {
                sh 'npm test'
            }
        
        }
        stage('Push image') {
            echo 'Pushing docker image'
            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
    }
    post {
        success {
            echo 'Shutdown EC2 istance'
            sh '"sudo halt" | at now'
            
        }
        failure {
            echo 'Sending email'
            mail to: "youssefbenmansour@gmail.com",
            subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}",
            body: "${currentBuild.currentResult}: ${env.JOB_NAME} Build Number: ${env.BUILD_NUMBER}"
            echo 'Shutdown EC2 istance'
            sh '"sudo halt" | at now'
            
        }
    }
}
