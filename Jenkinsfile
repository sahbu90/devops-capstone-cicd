
pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'ROLLBACK_TEST',
            defaultValue: false,
            description: 'Force a post-deployment failure to test automatic rollback'
        )
    }

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    environment {
        IMAGE_NAME = 'devops-capstone-web'
        CONTAINER_NAME = 'devops-capstone-app'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh '''
                    set -eu

                    python3 -m venv .venv-ci
                    . .venv-ci/bin/activate

                    pip install --no-cache-dir -r requirements.txt
                    python -m pytest -v
                '''
            }
        }

         stage('Build Docker Image') {
            steps {
                sh '''
                    set -eu

                    ECR_REGISTRY="393080455637.dkr.ecr.ap-southeast-2.amazonaws.com"
                    ECR_IMAGE="${ECR_REGISTRY}/${IMAGE_NAME}"

                    echo "Building image: ${IMAGE_NAME}:${BUILD_NUMBER}"

                    docker build \
                        -t "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        -t "${IMAGE_NAME}:latest" .

                    echo "Authenticating with Amazon ECR..."

                    aws ecr get-login-password --region ap-southeast-2 \
                        | docker login \
                            --username AWS \
                            --password-stdin "${ECR_REGISTRY}"

                    echo "Tagging image for ECR..."

                    docker tag "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        "${ECR_IMAGE}:${BUILD_NUMBER}"

                    echo "Pushing image to ECR..."

                    docker push "${ECR_IMAGE}:${BUILD_NUMBER}"

                    echo "ECR push successful: ${ECR_IMAGE}:${BUILD_NUMBER}"
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    set -eu

                    ECR_REGISTRY="393080455637.dkr.ecr.ap-southeast-2.amazonaws.com"
                    NEW_IMAGE="${ECR_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    DEPLOYMENT="devops-capstone-app"
                    CONTAINER="devops-capstone-app"

                    echo "Configuring EKS access..."
                    aws eks update-kubeconfig \
                        --region ap-southeast-2 \
                        --name capstone-eks

                    echo "Checking current deployment image..."
                    OLD_IMAGE=$(kubectl get deployment "$DEPLOYMENT" \
                        -o jsonpath="{.spec.template.spec.containers[?(@.name=='${CONTAINER}')].image}")

                    echo "Previous image: $OLD_IMAGE"
                    echo "New image: $NEW_IMAGE"

                    if [ -z "$OLD_IMAGE" ]; then
                        echo "ERROR: Could not determine previous image."
                        exit 1
                    fi

                    if [ "${ROLLBACK_TEST:-false}" = "true" ]; then
                        echo "ROLLBACK TEST: Deploying an intentionally invalid image."
                        TARGET_IMAGE="${ECR_REGISTRY}/${IMAGE_NAME}:rollback-test-invalid"
                    else
                        TARGET_IMAGE="$NEW_IMAGE"
                    fi

                    echo "Updating Kubernetes Deployment..."
                    kubectl set image deployment/"$DEPLOYMENT" \
                        "$CONTAINER=$TARGET_IMAGE"

                    echo "Waiting for Kubernetes rollout..."
                    if kubectl rollout status deployment/"$DEPLOYMENT" \
                        --timeout=120s; then

                        if [ "${ROLLBACK_TEST:-false}" = "true" ]; then
                            echo "ERROR: Rollback test did not trigger a deployment failure."
                            exit 1
                        fi

                        echo "Deployment successful."
                        kubectl get deployment "$DEPLOYMENT"
                        kubectl get pods -l app=devops-capstone-app
                    else
                        echo "Deployment failed. Rolling back to previous revision..."

                        kubectl rollout undo deployment/"$DEPLOYMENT"

                        echo "Waiting for rollback to complete..."
                        kubectl rollout status deployment/"$DEPLOYMENT" \
                            --timeout=120s

                        RESTORED_IMAGE=$(kubectl get deployment "$DEPLOYMENT" \
                            -o jsonpath="{.spec.template.spec.containers[?(@.name=='${CONTAINER}')].image}")

                        echo "Restored image: $RESTORED_IMAGE"

                        if [ "$RESTORED_IMAGE" != "$OLD_IMAGE" ]; then
                            echo "CRITICAL: Rollback image verification failed."
                            exit 1
                        fi

                        echo "Rollback successful."

                        if [ "${ROLLBACK_TEST:-false}" = "true" ]; then
                            echo "Rollback test completed successfully."
                            exit 0
                        fi

                        exit 1
                    fi
                '''
            }
        }
    }
}
