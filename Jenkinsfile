
pipeline {
    agent any

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
                    set -e
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
                    set -e
                    docker build \
                      -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                      -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    set -eu

                    CANDIDATE="devops-capstone-candidate-${BUILD_NUMBER}"

                    cleanup() {
                        docker rm -f "$CANDIDATE" >/dev/null 2>&1 || true
                    }
                    trap cleanup EXIT

                    docker run -d \
                      --name "$CANDIDATE" \
                      -p 127.0.0.1:5001:5000 \
                      "${IMAGE_NAME}:${BUILD_NUMBER}"

                    healthy=false

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:5001/health; then
                            healthy=true
                            break
                        fi
                        sleep 2
                    done

                    if [ "$healthy" != true ]; then
                        echo "Candidate health check failed; keeping current app."
                        exit 1
                    fi

                    docker rm -f "$CONTAINER_NAME" || true

                    docker run -d \
                      --name "$CONTAINER_NAME" \
                      --restart unless-stopped \
                      -p 127.0.0.1:5000:5000 \
                      "${IMAGE_NAME}:${BUILD_NUMBER}"

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:5000/health; then
                            echo "Deployment health check passed."
                            exit 0
                        fi
                        sleep 2
                    done

                    echo "Deployment health check failed."
                    exit 1
                '''
            }
        }
    }
}

