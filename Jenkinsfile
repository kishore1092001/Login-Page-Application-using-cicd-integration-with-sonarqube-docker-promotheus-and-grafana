pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'  // Update with the correct ID
        IMAGE_NAME = "kishore1092001/application:latest"
    }

    stages {
        stage('Install Docker') {
            steps {
                sh '''
                if ! [ -x "$(command -v docker)" ]; then
                  echo "Docker is not installed. Installing Docker..."
                  curl -fsSL https://get.docker.com -o get-docker.sh
                  sudo sh get-docker.sh
                  sudo usermod -aG docker $USER
                  newgrp docker
                else
                  echo "Docker is already installed."
                fi
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                // Clone the GitHub repository
                git branch: 'master', url: 'https://github.com/kishore1092001/Login-Page-Application-using-cicd-integration-with-sonarqube-docker-promotheus-and-grafana.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        sh 'docker push ${IMAGE_NAME}'
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                // Pull and run the Docker image on the Jenkins server
                sh '''
                docker pull ${IMAGE_NAME}
                docker run -d -p 80:80 ${IMAGE_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo "Application deployed successfully!"
        }
        failure {
            echo "Deployment failed."
        }
    }
}
