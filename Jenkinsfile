pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'uperve300/devops-app:latest'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-creds')  // Add in Jenkins
        PROD_SERVER = 'ubuntu@3.94.4.57'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'echo "Hello DevOps!" > app.txt'
            }
        }

        stage('Docker Build & Push') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $DOCKER_IMAGE .'

                echo 'Logging in to Docker Hub...'
                sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'

                echo 'Pushing image to Docker Hub...'
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo 'Running Ansible playbook to configure server...'
                sh '''
                ansible-playbook -i "$PROD_SERVER," playbook.yml --private-key ~/.ssh/devops.pem
                '''
            }
        }

        stage('Kubernetes Deploy') {
            steps {
                echo 'Deploying app on Kubernetes cluster...'
                sh '''
                kubectl apply -f k8s/deployment.yml
                kubectl apply -f k8s/service.yml
                '''
            }
        }
    }
}
