
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

                    docker build \
                        -t "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        -t "${IMAGE_NAME}:latest" .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    set -eu

                    CANDIDATE="devops-capstone-candidate-${BUILD_NUMBER}"
                    NEW_IMAGE="${IMAGE_NAME}:${BUILD_NUMBER}"
                    OLD_IMAGE=$(docker inspect "$CONTAINER_NAME" \
                        --format '{{.Config.Image}}')

                    echo "Previous image: $OLD_IMAGE"
                    echo "New image: $NEW_IMAGE"
                    echo "Rollback test mode: ${ROLLBACK_TEST:-false}"

                    cleanup() {
                        docker rm -f "$CANDIDATE" >/dev/null 2>&1 || true
                    }
                    trap cleanup EXIT

                    # Step 1: Start the candidate on a separate port.
                    docker run -d \
                        --name "$CANDIDATE" \
                        -p 127.0.0.1:5001:5000 \
                        "$NEW_IMAGE"

                    # Step 2: Check the candidate before replacing production.
                    candidate_healthy=false

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:5001/health; then
                            candidate_healthy=true
                            break
                        fi
                        sleep 2
                    done

                    if [ "$candidate_healthy" != true ]; then
                        echo "Candidate failed. Existing application retained."
                        exit 1
                    fi

                    echo "Candidate is healthy."

                    # Step 3: Replace the existing application.
                    docker rm -f "$CONTAINER_NAME"

                    if ! docker run -d \
                        --name "$CONTAINER_NAME" \
                        --restart unless-stopped \
                        -p 127.0.0.1:5000:5000 \
                        "$NEW_IMAGE"; then

                        echo "New container failed to start. Rolling back."

                        docker rm -f "$CONTAINER_NAME" \
                            >/dev/null 2>&1 || true

                        docker run -d \
                            --name "$CONTAINER_NAME" \
                            --restart unless-stopped \
                            -p 127.0.0.1:5000:5000 \
                            "$OLD_IMAGE"

                        exit 1
                    fi

                    # Step 4: Verify the new deployment.
                    deployed=false

                    for i in $(seq 1 15); do
                        if curl -fsS http://127.0.0.1:5000/health; then
                            deployed=true
                            break
                        fi
                        sleep 2
                    done

                    # Step 5: Test-only switch to simulate a deployment failure.
                    if [ "${ROLLBACK_TEST:-false}" = "true" ]; then
                        echo "ROLLBACK TEST: Forcing the health check to fail."
                        deployed=false
                    fi

                    # Step 6: Restore the previous image if deployment failed.
                    if [ "$deployed" != true ]; then
                        echo "Deployment unhealthy. Rolling back to $OLD_IMAGE."

                        docker rm -f "$CONTAINER_NAME" \
                            >/dev/null 2>&1 || true

                        docker run -d \
                            --name "$CONTAINER_NAME" \
                            --restart unless-stopped \
                            -p 127.0.0.1:5000:5000 \
                            "$OLD_IMAGE"

                        rollback_healthy=false

                        for i in $(seq 1 15); do
                            if curl -fsS http://127.0.0.1:5000/health; then
                                rollback_healthy=true
                                break
                            fi
                            sleep 2
                        done

                        if [ "$rollback_healthy" != true ]; then
                            echo "CRITICAL: Rollback health check failed."
                            exit 1
                        fi

                        RESTORED_IMAGE=$(docker inspect "$CONTAINER_NAME" \
                            --format '{{.Config.Image}}')

                        if [ "$RESTORED_IMAGE" != "$OLD_IMAGE" ]; then
                            echo "CRITICAL: Restored image does not match."
                            exit 1
                        fi

                        echo "Rollback successful. Restored image: $RESTORED_IMAGE"

                        # Expected failure in test mode: rollback was exercised.
                        if [ "${ROLLBACK_TEST:-false}" = "true" ]; then
                            echo "Rollback test completed successfully."
                            exit 1
                        fi

                        exit 1
                    fi

                    # Step 7: Confirm the deployed image.
                    DEPLOYED_IMAGE=$(docker inspect "$CONTAINER_NAME" \
                        --format '{{.Config.Image}}')

                    echo "Deployment successful: $DEPLOYED_IMAGE"
                '''
            }
        }
    }
}
