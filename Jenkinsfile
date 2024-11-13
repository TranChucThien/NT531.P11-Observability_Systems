pipeline {
    agent any

    environment {
        timestamp = "${new Date().format('yyyyMMddHHmmss')}" // Define timestamp variable
    }

    stages {
        stage('Authenticate with Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Logged in to Docker Hub'
                }
            }
        }

        stage('Build image') {
            steps {
                sh '''
                docker build --no-cache ./api_gateway --file ./api_gateway/Dockerfile --tag chucthien03/gateway-service:${timestamp}
                docker build --no-cache ./auth_service --file ./auth_service/Dockerfile --tag chucthien03/auth-microservice:${timestamp}
                docker build --no-cache ./comment_service --file ./comment_service/Dockerfile --tag chucthien03/comment-service:${timestamp}
                docker build --no-cache ./frontend --file ./frontend/Dockerfile --tag chucthien03/mern-stack-frontend:${timestamp}
                docker build --no-cache ./post_service --file ./post_service/Dockerfile --tag chucthien03/post-microservice:${timestamp}
                '''
            }
}

        stage('Push images to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Pushing images to Docker Hub...'
                    sh '''
                        docker push chucthien03/gateway-service:${timestamp}
                        docker push chucthien03/auth-microservice:${timestamp}
                        docker push chucthien03/comment-service:${timestamp}
                        docker push chucthien03/mern-stack-frontend:${timestamp}
                        docker push chucthien03/post-microservice:${timestamp}
                    '''
                }
            }
    }

    
    }

    post {
        always {
            echo 'Cleaning...'
            sh 'docker logout'
        }
        success {
            echo 'Deployment to Dev Environment is successful!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Success: ${currentBuild.fullDisplayName}",
                     body: "Pipeline completed successfully. Find attached Trivy report.",
                     attachmentsPattern: 'trivy-report.txt'
        }
        failure {
            echo 'Deployment to Dev Environment failed!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Failure: ${currentBuild.fullDisplayName}",
                     body: "Pipeline failed. Please check the logs for details.",
                     attachmentsPattern: 'trivy-report.txt'
        }
        unstable {
            echo 'Deployment to Dev Environment is unstable!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Unstable: ${currentBuild.fullDisplayName}",
                     body: "Pipeline completed but unstable."
        }
        changed {
            echo 'Deployment to Dev Environment is changed!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Changed: ${currentBuild.fullDisplayName}",
                     body: "Pipeline state changed."
        }
    }
}
