# 09 - Jenkins to EKS CI/CD Integration

## Objective
Integrate the Jenkins CI/CD pipeline with Amazon EKS for Kubernetes application deployment and automated rollback.

## Environment
- AWS Region: ap-southeast-2
- EKS Cluster: capstone-eks
- Kubernetes Deployment: devops-capstone-app
- Kubernetes Service: devops-capstone-service
- ECR Repository: devops-capstone-web
- Jenkins Job: devops-capstone-pipeline
- Git Branch: main
- Application Replicas: 2

## Implementation Completed
1. Replaced the EC2 Docker deployment stage with an EKS deployment stage.
2. Configured EKS kubeconfig for the Jenkins service user.
3. Verified Jenkins AWS identity using EC2-ECR-Push-Role.
4. Verified access to EKS worker nodes.
5. Added Kubernetes image update using kubectl set image.
6. Added rollout verification using kubectl rollout status.
7. Implemented rollback using kubectl rollout undo.
8. Reused the ROLLBACK_TEST parameter for EKS rollback testing.
9. Added Git ignore rules for local Jenkinsfile backups and kubectl executable.
10. Integrated application testing, Docker image build, ECR push, and EKS deployment into Jenkins.

## Validation Results

### Infrastructure and Access
- Jenkins service user AWS identity: Passed
- Jenkins service user EKS access: Passed
- EKS worker nodes Ready: 2
- EKS deployment shell syntax: Passed
- Git diff whitespace check: Passed
- Git ignore verification: Passed

### Jenkins Build #22 - Successful Deployment
- GitHub source checkout: Passed
- Python application tests: 2 passed
- Docker image build: Passed
- ECR image push (tag 22): Passed
- EKS deployment image update: Passed
- Kubernetes rollout verification: Passed
- Deployment replicas: 2/2 Ready
- Jenkins pipeline result: SUCCESS

### Jenkins Build #23 - Automated Rollback Test
- Python application tests: 2 passed
- Docker image build and ECR push (tag 23): Passed
- Intentional invalid image deployment: Triggered
- Rollout timeout detected: Passed
- Automatic kubectl rollout undo: Passed
- Previous image (tag 22) restored: Confirmed
- Rollback rollout verification: Passed
- Jenkins pipeline result: SUCCESS

### Public Application Health Verification
- Application endpoint: HTTP 200 OK
- Application status: running
- Application version: 1.0.1
- Health after rollback: Verified

## Important Files
- Jenkinsfile
- k8s/deployment.yaml
- k8s/service.yaml
- terraform/main.tf
- terraform/modules/eks/

## Outcome
Jenkins CI/CD integration with Amazon EKS is successfully implemented and validated. Both normal deployment and automated rollback have been tested successfully. The application remained accessible after rollback.
