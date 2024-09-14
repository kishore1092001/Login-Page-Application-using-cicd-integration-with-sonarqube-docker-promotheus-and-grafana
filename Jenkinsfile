pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'c099d980-79b7-49a0-a38e-a5aebcb6c27b' // Docker credentials ID in Jenkins
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm // This will use the configured GitHub repository
            }
        }

        stage('Install Docker (If Necessary)') {
            steps {
                script {
                    if (!fileExists("/usr/bin/docker")) {
                        sh '''
                        curl -fsSL https://get.docker.com -o get-docker.sh
                        sudo sh get-docker.sh
                        sudo usermod -aG docker $USER
                        newgrp docker
                        sudo chmod 666 /var/run/docker.sock
                        '''
                    }
                }
            }
        }

        stage('Docker Info') {
            steps {
                sh 'docker info'
            }
        }

        stage('Set up Docker Buildx') {
            steps {
                sh '''
                docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
                docker buildx create --name mybuilder --use
                docker buildx inspect --bootstrap
                '''
            }
        }

        stage('Log in to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        '''
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                sh '''
                docker buildx build --platform linux/amd64,linux/arm64 -t kishore1092001/simple-app:latest --push .
                '''
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh '''
                docker pull kishore1092001/simple-app:latest

                if [ "$(docker ps -q -f name=simple-app)" ]; then
                    docker stop simple-app
                    docker rm simple-app
                fi

                docker run -d --name simple-app -p 80:80 kishore1092001/simple-app:latest
                '''
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up the workspace after the build
        }
    }
}
