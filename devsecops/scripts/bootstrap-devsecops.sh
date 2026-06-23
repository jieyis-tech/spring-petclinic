#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEVSECOPS_DIR="$PROJECT_ROOT/devsecops"

cd "$DEVSECOPS_DIR"

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created devsecops/.env from .env.example. Update passwords/tokens before a graded demo."
fi

docker compose up -d --build

cat <<'EOF'
Jenkins:    http://localhost:8081
SonarQube:  http://localhost:9000
Prometheus: http://localhost:9090
Grafana:    http://localhost:3000
ZAP API:    http://localhost:8090
EOF
