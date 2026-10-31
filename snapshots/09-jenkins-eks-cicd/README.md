# 09 - Jenkins to EKS CI/CD Integration

## Objective
Integrate the Jenkins CI/CD pipeline with Amazon EKS for Kubernetes application deployment and rollback.

## Environment
- AWS Region: ap-southeast-2
- EKS Cluster: capstone-eks
- Kubernetes Deployment: devops-capstone-app
- Kubernetes Service: devops-capstone-service
- ECR Repository: devops-capstone-web
- Jenkins Job: devops-capstone-pipeline
- Git Branch: main

## Implementation Completed
1. Replaced the EC2 Docker deployment stage with an EKS deployment stage.
2. Configured EKS kubeconfig for the Jenkins service user.
3. Verified Jenkins AWS identity using EC2-ECR-Push-Role.
4. Verified access to both EKS worker nodes.
5. Added Kubernetes image update using kubectl set image.
6. Added rollout verification using kubectl rollout status.
7. Added rollback using kubectl rollout undo.
8. Reused the existing ROLLBACK_TEST parameter for EKS rollback testing.
9. Added Git ignore rules for local Jenkinsfile backups and kubectl executable.

## Validation Results
- Jenkins service user AWS identity: Passed
- Jenkins service user EKS access: Passed
- EKS worker nodes Ready: 2
- EKS deployment shell syntax: Passed
- Git diff whitespace check: Passed
- Git ignore verification: Passed

## Pending Validation
- Jenkins Declarative Pipeline validation
- Actual Jenkins pipeline execution
- ECR image deployment through Jenkins
- Automatic rollback test
- Post-deployment application health verification

## Important Files
- Jenkinsfile
- k8s/deployment.yaml
- k8s/service.yaml
- terraform/main.tf
- terraform/modules/eks/
