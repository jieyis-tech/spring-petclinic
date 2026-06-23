pipeline {
  agent any

  triggers {
    pollSCM('H/2 * * * *')
  }

  options {
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '20'))
    disableConcurrentBuilds()
    timestamps()
  }

  parameters {
    string(name: 'PROD_URL', defaultValue: 'http://production-vm:8080', description: 'Production PetClinic URL used by smoke tests and ZAP.')
    booleanParam(name: 'RUN_ZAP', defaultValue: true, description: 'Run OWASP ZAP baseline scan after deployment.')
    booleanParam(name: 'RUN_DEPLOY', defaultValue: true, description: 'Deploy the built jar to the production VM with Ansible.')
  }

  environment {
    APP_NAME = 'spring-petclinic'
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    MAVEN_OPTS = '-Dmaven.repo.local=/var/jenkins_home/.m2/repository'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build and Unit Tests') {
      steps {
        sh 'chmod +x mvnw'
        sh './mvnw -B clean verify'
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
        }
      }
    }

    stage('SonarQube Static Analysis') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh './mvnw -B org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=spring-petclinic -Dsonar.projectName=spring-petclinic'
        }
      }
    }

    stage('Package Artifact') {
      steps {
        sh './mvnw -B -DskipTests package'
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }

    stage('Deploy to Production VM') {
      when {
        expression { return params.RUN_DEPLOY }
      }
      steps {
        sh '''
          set -eu
          test -f devsecops/ansible/inventory.ini || {
            echo "Create devsecops/ansible/inventory.ini from inventory.ini.example before deployment."
            exit 1
          }
          ARTIFACT="$(ls target/spring-petclinic-*.jar | head -n 1)"
          ansible-playbook \
            -i devsecops/ansible/inventory.ini \
            devsecops/ansible/deploy_petclinic.yml \
            --extra-vars "petclinic_artifact=${ARTIFACT}"
        '''
      }
    }

    stage('Production Smoke Test') {
      when {
        expression { return params.RUN_DEPLOY }
      }
      steps {
        sh '''
          set -eu
          mkdir -p target/evidence
          curl -fsS "${PROD_URL}/" -o target/evidence/production-welcome.html
          grep -q "DevSecOps automated deployment release v1" target/evidence/production-welcome.html
        '''
        archiveArtifacts artifacts: 'target/evidence/production-welcome.html', fingerprint: true
      }
    }

    stage('OWASP ZAP Baseline Scan') {
      when {
        expression { return params.RUN_ZAP }
      }
      steps {
        sh '''
          set -eu
          mkdir -p zap-reports
          docker run --rm \
            --network devsecops-net \
            -v "$WORKSPACE:/zap/wrk:rw" \
            ghcr.io/zaproxy/zaproxy:stable \
            zap-baseline.py \
              -t "${PROD_URL}" \
              -c /zap/wrk/devsecops/zap/zap-baseline.conf \
              -r zap-reports/zap-baseline.html \
              -J zap-reports/zap-baseline.json \
              -x zap-reports/zap-baseline.xml || true
        '''
      }
      post {
        always {
          archiveArtifacts allowEmptyArchive: true, artifacts: 'zap-reports/*'
          publishHTML(target: [
            allowMissing: true,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: 'zap-reports',
            reportFiles: 'zap-baseline.html',
            reportName: 'OWASP ZAP Baseline'
          ])
        }
      }
    }
  }

  post {
    success {
      echo 'DevSecOps pipeline completed successfully.'
    }
    always {
      cleanWs(deleteDirs: true, notFailBuild: true)
    }
  }
}
