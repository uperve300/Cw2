pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'uperve300/devops-app:latest'
        PROD_SERVER = 'ubuntu@3.94.4.57'
        SSH_KEY = '~/.ssh/devops.pem'
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
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR', passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW')]) {
                    sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                }

                echo 'Pushing image to Docker Hub...'
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo 'Running Ansible playbook to configure server...'
                sh '''
                    chmod 600 $SSH_KEY
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $PROD_SERVER \
                        "ansible-playbook -i $PROD_SERVER, playbook.yml --private-key $SSH_KEY"
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
