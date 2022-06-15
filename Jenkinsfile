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
        
        stage('Unit tests') {
            steps {
               echo 'Unit tests'
               script {
                   sh '''
                     export DOCKER_BUILDKIT=1
                     dockerImage = docker.build(imagename, "-f Dockerfile.prod .")
                     docker run imagename npm run test
                   '''            
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
