# Phase 10 – Monitoring and Alerting

## Objective
Implemented Kubernetes monitoring and alerting for the DevOps Capstone application using Prometheus, Grafana, Alertmanager, and kube-prometheus-stack.

## Implementation
- Installed kube-prometheus-stack using Helm.
- Deployed Prometheus for metrics collection.
- Deployed Grafana for monitoring dashboards and visualization.
- Deployed Alertmanager for alert management.
- Monitored Kubernetes cluster, nodes, pods, CPU, memory, and networking.
- Verified Prometheus targets and metrics collection.
- Created a custom PrometheusRule for the DevOps Capstone application.

## Custom Application Alerts
1. **DevOpsCapstoneAppReplicasUnavailable** – Detects when available application replicas are fewer than desired replicas.
2. **DevOpsCapstoneAppContainerRestart** – Detects application container restarts.
3. **DevOpsCapstoneAppPodNotReady** – Detects application pods that remain not ready.

All three custom rules were successfully loaded by Prometheus. They were inactive during final validation because the application was healthy.

## Alertmanager Validation
- Verified Prometheus-to-Alertmanager connectivity.
- Created a temporary test alert.
- Confirmed that the test alert reached Alertmanager.
- Deleted the temporary test rule after successful validation.

Note: Alertmanager connectivity and alert receipt were verified. External notification delivery (email, Slack, or SNS) has not been configured.

## Evidence
| File | Description |
|---|---|
| monitoring-validation.txt | Monitoring resources, application deployment, PrometheusRule, and alert rule validation |
| 01-grafana-cluster-dashboard.png | Grafana Kubernetes networking/cluster dashboard |
| 02-grafana-kubernetes-cluster-cpu-memory.png | Kubernetes cluster CPU and memory metrics |
| 03-grafana-application-pod-cpu.png | Application pod CPU metrics |
| 04-grafana-application-pod-memory.png | Application pod memory metrics |
| 06-grafana-custom-alert-rules.jpg | Grafana custom alert rules |
| 07-prometheus-targets-up.jpg | Prometheus target health |
| 08-alertmanager-connectivity.jpg | Alertmanager UI and connectivity evidence |

## Result
Kubernetes monitoring, dashboard visualization, custom application alert rules, and Prometheus-to-Alertmanager connectivity were successfully implemented and validated.
