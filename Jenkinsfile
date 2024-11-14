pipeline {
    agent any

    environment {
        timestamp = "${new Date().format('yyyyMMddHHmmss')}"
    }

    stages {
        stage('Authenticate with Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Logged in to Docker Hub'
                }
            }
        }

        stage('Build Images') {
            steps {
                sh '''
                    whoami
                    docker build ./api_gateway --file ./api_gateway/Dockerfile --tag chucthien03/gateway-service:${timestamp}
                    docker build ./auth_service --file ./auth_service/Dockerfile --tag chucthien03/auth-microservice:${timestamp}
                    docker build ./post_service --file ./post_service/Dockerfile --tag chucthien03/post-microservice:${timestamp}
                    # docker build ./frontend --file ./frontend/Dockerfile --tag chucthien03/mern-stack-frontend:${timestamp}
                    docker build ./comment_service --file ./comment_service/Dockerfile --tag chucthien03/comment-service:${timestamp}
                '''
            }
        }

        stage('Scan Images with Trivy') {
            steps {
                sh '''
                    #trivy image --severity CRITICAL chucthien03/gateway-service:${timestamp} --exit-code 1
                    #trivy image --severity CRITICAL chucthien03/auth-microservice:${timestamp} --exit-code 1
                    #trivy image --severity CRITICAL chucthien03/comment-service:${timestamp} --exit-code 1
                    # trivy image --severity CRITICAL chucthien03/mern-stack-frontend:${timestamp} --exit-code 1
                    #trivy image --severity CRITICAL chucthien03/post-microservice:${timestamp} --exit-code 1
                '''
            }
        }

        stage('Push Images to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-account', url: 'https://index.docker.io/v1/') {
                    echo 'Pushing images to Docker Hub...'
                    sh '''
                        docker push chucthien03/gateway-service:${timestamp}
                        docker push chucthien03/auth-microservice:${timestamp}
                        docker push chucthien03/comment-service:${timestamp}
                        # docker push chucthien03/mern-stack-frontend:${timestamp}
                        docker push chucthien03/post-microservice:${timestamp}
                    '''
                }
            }
        }

         stage('Check K8s Previous Images Version') {
            steps {
                echo 'Updating Kubernetes deployments with new image versions...'
                sh '''
                   kubectl get deployments -o custom-columns="DEPLOYMENT NAME:.metadata.name,IMAGE:.spec.template.spec.containers[*].image"
                    

                '''
            }
        }

        


        stage('Update K8s Deployments') {
            steps {
                echo 'Updating Kubernetes deployments with new image versions...'
                sh '''
                    whoami
                    kubectl set image deployment/gateway-deployment gateway-c=chucthien03/gateway-service:${timestamp}
                    kubectl set image deployment/auth-microservice-deployment auth-microservice-c=chucthien03/auth-microservice:${timestamp}
                    kubectl set image deployment/comment-microservice-deployment comment-microservice-c=chucthien03/comment-service:${timestamp}
                    #kubectl set image deployment/frontend-deployment frontend-c=chucthien03/mern-stack-frontend:${timestamp}
                    kubectl set image deployment/post-microservice-deployment post-microservice-c=chucthien03/post-microservice:${timestamp}
                    
                    

                '''
            }
        }

        stage('Check K8s Current Images Version') {
            steps {
                echo 'Updating Kubernetes deployments with new image versions...'
                sh '''
                   kubectl get deployments -o custom-columns="DEPLOYMENT NAME:.metadata.name,IMAGE:.spec.template.spec.containers[*].image"
                    

                '''
            }
        }

        stage('Clean Up Docker Images') {
            steps {
                echo 'Removing local Docker images...'
                sh '''
                    docker rmi chucthien03/gateway-service:${timestamp} || true
                    docker rmi chucthien03/auth-microservice:${timestamp} || true
                    docker rmi chucthien03/comment-service:${timestamp} || true
                    # docker rmi chucthien03/mern-stack-frontend:${timestamp} || true
                    docker rmi chucthien03/post-microservice:${timestamp} || true
                    docker image prune -af
                '''
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
                     body: "Pipeline completed successfully. Find attached Trivy report."
        }
        failure {
            echo 'Deployment to Dev Environment failed!'
            emailext from: 'tranchucthienmt@gmail.com',
                     to: 'tranchucthienmt@gmail.com',
                     subject: "Pipeline Failure: ${currentBuild.fullDisplayName}",
                     body: "Pipeline failed. Please check the logs for details."
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
