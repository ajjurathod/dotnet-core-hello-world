pipeline {
    agent { label 'kube' }
      environment {
        SONAR_AUTH_TOKEN = credentials('sonar-token')  
    }
    stages {
        stage('Code Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ajjurathod/dotnet-core-hello-world.git'
            }
        }

        stage('Source Code Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {  
                sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=dotnet \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://3.148.195.74/sonarqube \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }
        
        stage('build docker image'){
            steps{
                sh " docker build -t ajjurathod1998/dotnet-core:v1.0.0 ."
            }
        }
        stage('image scanning with trivy'){
            steps{
                sh "trivy image ajjurathod1998/dotnet-core:v1.0.0 "
            }
        }
        
        
        stage('pushing image to dockerhub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'passwordVariable', usernameVariable: 'usernameVariable')]) {
                sh "echo $passwordVariable | docker login -u $usernameVariable --password-stdin"
                sh "docker push ajjurathod1998/dotnet-core:v1.0.0 "
             }
            }
        }
        stage('deploying the application'){
            steps{
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
            }
        }
        
    }
}    
