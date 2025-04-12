pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'uperve300/devops-app:latest'
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-creds')
        SSH_KEY = '/var/lib/jenkins/.ssh/devops.pem'
        PROD_SERVER = 'ubuntu@3.94.4.57'
    }

    triggers {
        pollSCM('* * * * *')  // (a) Automatically detect GitHub changes every minute
    }

    stages {

        stage('Build Docker Image') { // (b)
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Run Build Test') { // (c)
            steps {
                echo 'Testing Docker container startup...'
                sh '''
                    docker run -d --name test-container $DOCKER_IMAGE
                    sleep 5
                    docker exec test-container echo "Container launched successfully"
                    docker stop test-container
                    docker rm test-container
                '''
            }
        }

        stage('Push Docker Image to DockerHub') { // (d)
            steps {
                echo 'Logging in to DockerHub and pushing image...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PASS')]) {
                    sh '''
                        echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') { // (e)
            steps {
                echo 'Deploying application to Kubernetes cluster...'
                sh '''
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $PROD_SERVER \
                        "kubectl set image deployment/devops-deployment devops-container=$DOCKER_IMAGE --record"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment pipeline completed successfully.'
        }
        failure {
            echo '❌ Deployment pipeline failed.'
        }
    }
}
