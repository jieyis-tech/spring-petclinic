# Project Documents

Use this file as the submission index for screenshots and the demo video link.

## Video

- Demo video link: https://www.youtube.com/watch?v=PrI1WNJacnI

## Required Screenshots

Screenshots are saved in `docs/evidence/`:

1. `01-jenkins-stage-view-success.png` - Jenkins Stage View showing the successful DevSecOps pipeline with build, SonarQube analysis, deployment, smoke test, and OWASP ZAP stages.
2. `02-jenkins-build-18-artifacts.png` - Jenkins build details showing the successful build, Git revision, production smoke-test artifact, application jar, and ZAP HTML/JSON/XML artifacts.
3. `03-zap-baseline-report.png` - OWASP ZAP baseline HTML report for the deployed production application.
4. `04-sonarqube-project-overview.png` - SonarQube project dashboard for `spring-petclinic` showing the Quality Gate result.
5. `05-production-petclinic-page.png` - production VM PetClinic welcome screen at `192.168.56.20:8080` showing `DevSecOps automated deployment release v1`.
6. `06-prometheus-targets-up.png` - Prometheus targets page showing Jenkins, production PetClinic, and Prometheus targets as `UP`.
7. `07-grafana-dashboard.png` - Grafana dashboard visualizing Jenkins metrics from Prometheus.
8. `8-blueocean.png` - Jenkins Blue Ocean pipeline visualization.
9. `9-Jenkins #19 console.png` - Jenkins build #19 console output for the SCM-triggered pipeline run.
10. `10-github-commit-diff.png` - GitHub commit diff showing the welcome page code change deployed by the pipeline.

## Evidence Checklist

- Jenkins runs inside Docker and is attached to `devsecops-net`.
- SonarQube runs inside Docker and receives analysis from Jenkins.
- Prometheus scrapes Jenkins metrics at `/prometheus`.
- Grafana uses Prometheus as its data source and shows Jenkins metrics.
- ZAP baseline scan runs after deployment and publishes an HTML report.
- Ansible deploys `target/spring-petclinic-*.jar` to the production VM.
- Production VM shows the updated PetClinic welcome page.
