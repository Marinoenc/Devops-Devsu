#!/usr/bin/env bash
set -euo pipefail
npm ci
npm run lint
npm run test:coverage
docker build -t demo-devops-nodejs:local .
docker run --rm -d --name demo-devops-nodejs -p 8000:8000 demo-devops-nodejs:local
sleep 8
curl -fsS http://localhost:8000/health
docker rm -f demo-devops-nodejs
