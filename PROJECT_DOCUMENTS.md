# Project Documents

Use this file as the submission index for screenshots and the demo video link.

## Video

- Demo video link: `<paste your video URL here>`

## Required Screenshots

Save screenshots in `docs/evidence/` with these suggested names:

1. `01-production-welcome-before.png` - production VM PetClinic welcome screen before the visible code change.
2. `02-jenkins-blue-ocean-pipeline.png` - Jenkins Blue Ocean pipeline visualization.
3. `03-sonarqube-project-analysis.png` - SonarQube project dashboard for `spring-petclinic`.
4. `04-prometheus-targets.png` - Prometheus targets page showing Jenkins and PetClinic targets.
5. `05-grafana-jenkins-dashboard.png` - Grafana dashboard visualizing Jenkins metrics.
6. `06-zap-baseline-report.png` - ZAP HTML report or ZAP container scan result.
7. `07-github-code-change.png` - committed welcome page code change.
8. `08-jenkins-auto-trigger.png` - Jenkins build triggered by SCM polling after the commit.
9. `09-production-welcome-after.png` - production VM welcome screen showing `DevSecOps automated deployment release v1`.

## Evidence Checklist

- Jenkins runs inside Docker and is attached to `devsecops-net`.
- SonarQube runs inside Docker and receives analysis from Jenkins.
- Prometheus scrapes Jenkins metrics at `/prometheus`.
- Grafana uses Prometheus as its data source and shows Jenkins metrics.
- ZAP baseline scan runs after deployment and publishes an HTML report.
- Ansible deploys `target/spring-petclinic-*.jar` to the production VM.
- Production VM shows the updated PetClinic welcome page.
