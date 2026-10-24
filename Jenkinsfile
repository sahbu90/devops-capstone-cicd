
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
                    NEW_IMAGE="${IMAGE_NAME}:${BUILD_NUMBER}"
                    OLD_IMAGE=$(docker inspect "$CONTAINER_NAME" --format '{{.Config.Image}}')

                    cleanup() {
                        docker rm -f "$CANDIDATE" >/dev/null 2>&1 || true
                    }
                    trap cleanup EXIT

                    echo "Previous image: $OLD_IMAGE"
                    echo "New image: $NEW_IMAGE"

                    docker run -d \
                      --name "$CANDIDATE" \
                      -p 127.0.0.1:5001:5000 \
                      "$NEW_IMAGE"

                    healthy=false

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:5001/health; then
                            healthy=true
                            break
                        fi
                        sleep 2
                    done

                    if [ "$healthy" != true ]; then
                        echo "Candidate check failed; existing app retained."
                        exit 1
                    fi

                    docker rm -f "$CONTAINER_NAME"

                    if docker run -d \
                      --name "$CONTAINER_NAME" \
                      --restart unless-stopped \
                      -p 127.0.0.1:5000:5000 \
                      "$NEW_IMAGE"; then
                        :
                    else
                        echo "New container failed to start; rolling back."
                        docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
                        docker run -d \
                          --name "$CONTAINER_NAME" \
                          --restart unless-stopped \
                          -p 127.0.0.1:5000:5000 \
                          "$OLD_IMAGE"
                        exit 1
                    fi

                    deployed=false

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:5000/health; then
                            deployed=true
                            break
                        fi
                        sleep 2
                    done

                    if [ "$deployed" != true ]; then
                        echo "New deployment unhealthy; rolling back."
                        docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
                        docker run -d \
                          --name "$CONTAINER_NAME" \
                          --restart unless-stopped \
                          -p 127.0.0.1:5000:5000 \
                          "$OLD_IMAGE"

                        for i in $(seq 1 15); do
                            if curl -fsS http://127.0.0.1:5000/health; then
                                echo "Previous image restored and healthy."
                                break
                            fi
                            sleep 2
                        done

                        exit 1
                    fi

                    echo "Deployment successful: $NEW_IMAGE"
                '''
            }
        }





    }
}

