def podYaml = readFile 'Manifests/kaniko-agent.yaml'
pipeline {
    agent {
        kubernetes {
            yaml podYaml
            label 'nodejs-pipeline'
            defaultContainer 'jnlp'
        }
    }
    environment {
        ECR_REGISTRY = "339007232055.dkr.ecr.us-east-1.amazonaws.com"
        IMAGE_REPO = "my-ecr"
        IMAGE_TAG = "1.1.${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                container('git') {
                    git branch: 'master', url: 'https://github.com/mahmoud254/jenkins_nodejs_example.git'
                }
            }
        }
        
        stage('Build and Push Image') {
            steps {
                container('kaniko') {
                    script {
                        sh """
                            /kaniko/executor \\
                                --dockerfile=dockerfile \\
                                --context=. \\
                                --destination=${ECR_REGISTRY}/${IMAGE_REPO}:${IMAGE_TAG} \\
                                --destination=${ECR_REGISTRY}/${IMAGE_REPO}:latest \\
                                --cache=true \\
                                --cache-ttl=24h
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "Build completed"
        }
        success {
            echo "Image pushed successfully to ${ECR_REGISTRY}/${IMAGE_REPO}:${IMAGE_TAG}"
        }
        failure {
            echo "Build failed"
        }
    }
}