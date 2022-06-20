pipeline {
   
    environment {
        imagename = "hackathon-starter"
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
        
      /* stage('Unit tests') {
            steps {
               echo 'Unit tests'
               script {
                    sh 'DOCKER_BUILDKIT=1 docker build --target export-test-results -f Dockerfile.test --output type=local,dest=results .' 
                    archiveArtifacts artifacts: 'results/*.xml'
               }
            }
       }
       
       stage('Sonar Scanner') {
            steps {
               echo 'Sonar Scanner'
               
               sh '''
                  docker network create scanner-sq-network
                  docker run -d --rm --network scanner-sq-network --name sonarqube -p 9000:9000 sonarqube
               '''
               
               timeout(time: 2, unit: 'MINUTES') {
                  waitUntil {
                     script {
                           sleep 20
                           final String response = sh(script: "curl -s -u admin:admin ${sonarQubeURL}api/system/health | jq -r  '.health'", returnStdout: true).trim()
                           echo response
                           return (response == 'GREEN');
                     }
                  }
               }
               
               withSonarQubeEnv('SonarQube') {
                  sh "${scannerHome}/bin/sonar-scanner -X"
               }
               
               sh '''
                  sleep 10
               '''
             
               script {
                    final String response = sh(script: "curl -s -u admin:admin ${sonarQubeURL}api/qualitygates/project_status?projectKey=hackathon-starter | jq '.projectStatus.status' | tr - d", returnStdout: true).trim()
                    echo response
                    if (response != '"OK"') {
                       error "Pipeline aboratdo por fallos de calidad: "+ response
                    } 
                }
            }
       }*/
       
       /*stage('Build') {
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
                    docker.withRegistry('https://673294157311.dkr.ecr.eu-west-3.amazonaws.com/hackathon-starter', 'ecr:eu-west-3:jenkins-aws-credentials') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
               }
            }
        }*/
       
       stage('Deploy'){
            steps {
                 /*sh 'kubectl apply -f deployment/'*/
               sh 'kubectl version --kubeconfig /home/ubuntu/.kube/config'
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
        }
    }
}
