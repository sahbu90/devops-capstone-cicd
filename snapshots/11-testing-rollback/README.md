# Phase 11 – Testing and Rollback

## Objective
Validate application availability, Kubernetes self-healing, deployment rollout history, and rollback recovery.

## Tests Performed

1. **Baseline Health Check**
   - Verified deployment with 2/2 available replicas.
   - Confirmed both application pods were Running.
   - Verified public LoadBalancer health endpoint returned HTTP 200.

2. **Kubernetes Self-Healing**
   - Intentionally deleted one application pod.
   - Kubernetes Deployment controller automatically created a replacement pod.
   - Verified both replicas returned to Running and Ready state.

3. **Application Availability**
   - Checked the public health endpoint after pod deletion.
   - Application continued returning HTTP 200.

4. **Deployment Revision Inspection**
   - Inspected deployment rollout history.
   - Compared the current image tag 24 with the previous stable image tag 22.

5. **Kubernetes Rollback**
   - Rolled back from image tag 24 to image tag 22.
   - Verified successful rollout and both replacement pods became Ready.
   - Confirmed the public health endpoint remained healthy.

6. **Restore Previous Current Version**
   - Restored image tag 24 after rollback testing.
   - Verified successful rollout, 2/2 available replicas, and HTTP 200 health response.

## Final Deployment State
- ECR image: devops-capstone-web:24
- Desired replicas: 2
- Available replicas: 2
- Pod status: Running
- Public health endpoint: HTTP 200 OK

## Evidence
- testing-rollback-validation.txt – Final deployment status, current image, pod status, rollout history, and public health check.

## Result
Kubernetes self-healing, application availability, deployment rollback, and restoration of the tested application version were successfully validated.
