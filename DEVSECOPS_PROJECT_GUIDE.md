# Spring PetClinic DevSecOps Mini Project Guide

## 1. Goal

This repository adds a complete DevSecOps pipeline for Spring PetClinic using Docker, Jenkins, SonarQube, OWASP ZAP, Prometheus, Grafana, and Ansible deployment to a production VM.

The pipeline builds and tests the application, runs static analysis, packages the jar, deploys it to a VM, verifies the deployed welcome page, runs a ZAP baseline scan, archives reports, and exposes Jenkins metrics for Prometheus/Grafana monitoring.

## 2. Repository Additions

- `Jenkinsfile` - CI/CD pipeline with SCM polling, Maven build, SonarQube analysis, Ansible deployment, smoke test, ZAP scan, and report publishing.
- `devsecops/docker-compose.yml` - Dockerized Jenkins, SonarQube, Prometheus, Grafana, and ZAP on the custom `devsecops-net` network.
- `devsecops/jenkins/` - Jenkins Docker image, plugin list, and Configuration as Code setup.
- `devsecops/prometheus/prometheus.yml` - Prometheus scrape configuration for Jenkins and production PetClinic.
- `devsecops/grafana/` - provisioned Prometheus data source and Jenkins dashboard.
- `devsecops/zap/zap-baseline.conf` - OWASP ZAP baseline scan policy.
- `devsecops/ansible/` - production inventory example, playbook, and systemd unit template.
- `devsecops/vagrant/Vagrantfile` - optional VirtualBox VM for the production web server.
- `PROJECT_DOCUMENTS.md` - screenshot and demo video submission checklist.

## 3. Prerequisites

Install these tools on the host machine:

- Docker Desktop or Docker Engine
- Git
- Java 17 or newer for local verification
- Vagrant and VirtualBox if using the included VM automation
- A GitHub or GitLab fork of this repository

## 4. Start the Production VM

Option A, use the included Vagrant VM:

```powershell
cd devsecops\vagrant
vagrant up
vagrant ssh-config
```

Copy the generated SSH details into `devsecops/ansible/inventory.ini`. The default example uses `192.168.56.20`.

Option B, use an existing Ubuntu VM:

1. Install Python 3 and ensure SSH access works.
2. Open port `8080` from the Jenkins container/host to the VM.
3. Copy `devsecops/ansible/inventory.ini.example` to `devsecops/ansible/inventory.ini`.
4. Update `ansible_host`, `ansible_user`, and SSH key path.

## 5. Start the DevSecOps Tool Stack

From PowerShell:

```powershell
.\devsecops\scripts\bootstrap-devsecops.ps1
```

Or from Bash:

```bash
./devsecops/scripts/bootstrap-devsecops.sh
```

The Docker Compose stack creates the custom `devsecops-net` network and starts:

- Jenkins: `http://localhost:8081`
- SonarQube: `http://localhost:9000`
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000`
- ZAP daemon/API: `http://localhost:8090`

Default demo credentials are in `devsecops/.env.example`. Change them before recording the final demo.

## 6. Configure SonarQube

1. Open `http://localhost:9000`.
2. Log in with the initial SonarQube credentials shown by the container or setup screen.
3. Create a project named `spring-petclinic`.
4. Generate a project token.
5. Put that token into `devsecops/.env` as `SONARQUBE_TOKEN`.
6. Restart Jenkins so Configuration as Code loads the token:

```powershell
cd devsecops
docker compose restart jenkins
```

## 7. Configure Jenkins Pipeline

1. Open `http://localhost:8081`.
2. Log in with `JENKINS_ADMIN_ID` and `JENKINS_ADMIN_PASSWORD`.
3. Confirm these plugins are installed: Blue Ocean, SonarQube Scanner, Prometheus, HTML Publisher, Docker Pipeline, and Pipeline.
4. Create a new Pipeline job named `spring-petclinic-devsecops`.
5. Set Pipeline definition to `Pipeline script from SCM`.
6. Set SCM to your forked GitHub/GitLab repository.
7. Set script path to `Jenkinsfile`.
8. Enable polling if not already detected from the Jenkinsfile trigger.

The Jenkinsfile contains:

```groovy
triggers {
  pollSCM('H/2 * * * *')
}
```

This checks SCM every two minutes for assignment demo purposes.

## 8. Run the Pipeline

Run the Jenkins job once manually, then use Blue Ocean to view stages:

1. Checkout
2. Build and Unit Tests
3. SonarQube Static Analysis
4. Package Artifact
5. Deploy to Production VM
6. Production Smoke Test
7. OWASP ZAP Baseline Scan

For the first run, set:

- `PROD_URL`: `http://production-vm:8080` or the URL of your VM
- `RUN_DEPLOY`: `true`
- `RUN_ZAP`: `true`

## 9. Verify Monitoring

Prometheus:

1. Open `http://localhost:9090/targets`.
2. Confirm the `jenkins` target is UP.
3. If the production VM is reachable from the Docker network as `production-vm:8080`, confirm `petclinic-production` is UP.

Grafana:

1. Open `http://localhost:3000`.
2. Log in with the Grafana credentials from `.env`.
3. Open the `PetClinic / Jenkins and PetClinic DevSecOps Overview` dashboard.
4. Confirm Jenkins metrics panels are populated.

## 10. Demonstrate Automatic Deployment

This repository includes a visible welcome page change:

```html
<p class="lead">DevSecOps automated deployment release v1</p>
```

To record the required evidence:

1. Capture the production welcome page before the change is deployed.
2. Commit and push the change to your fork.
3. Wait for Jenkins SCM polling to trigger the pipeline automatically.
4. Capture Blue Ocean showing the triggered pipeline.
5. After deployment, refresh the VM URL and capture the welcome page showing `DevSecOps automated deployment release v1`.

## 11. ZAP Report

The pipeline runs:

```bash
zap-baseline.py -t "$PROD_URL"
```

Reports are archived under `zap-reports/` and published in Jenkins through the HTML Publisher plugin.

## 12. Submission Checklist

Submit these files and evidence:

- This repository with `Jenkinsfile`, `devsecops/`, `DEVSECOPS_PROJECT_GUIDE.md`, and `PROJECT_DOCUMENTS.md`.
- Screenshots listed in `PROJECT_DOCUMENTS.md`.
- Demo video link in `PROJECT_DOCUMENTS.md`.
- Evidence that the production welcome screen changed after a commit and automatic Jenkins deployment.
