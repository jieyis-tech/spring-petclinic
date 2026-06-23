param(
  [string]$ProjectRoot = (Resolve-Path "$PSScriptRoot\..\..").Path
)

$ErrorActionPreference = "Stop"
$DevSecOpsDir = Join-Path $ProjectRoot "devsecops"

Write-Host "Starting PetClinic DevSecOps stack from $DevSecOpsDir"
Set-Location $DevSecOpsDir

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created devsecops/.env from .env.example. Update passwords/tokens before a graded demo."
}

docker compose up -d --build

Write-Host "Jenkins:    http://localhost:8081"
Write-Host "SonarQube:  http://localhost:9000"
Write-Host "Prometheus: http://localhost:9090"
Write-Host "Grafana:    http://localhost:3000"
Write-Host "ZAP API:    http://localhost:8090"
