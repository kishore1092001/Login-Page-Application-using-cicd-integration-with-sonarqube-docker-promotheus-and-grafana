pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'  // Update with your Docker Hub credentials ID
        IMAGE_NAME = "kishore1092001/application:latest"
    }

    stages {
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
