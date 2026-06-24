# DevOps Prueba Técnica - Node.js + Docker + Kubernetes + Azure

Solución basada en la aplicación `demo-devops-nodejs` del starter project. El proyecto queda listo para versionarse en GitHub público y cumplir los puntos solicitados: Dockerización, CI/CD, pruebas, análisis estático, coverage, build/push de imagen, despliegue a Kubernetes, documentación e IaC opcional en Azure.

## Stack usado

- Node.js 18
- Express
- SQLite
- Jest + Supertest
- ESLint
- Docker
- GitHub Actions
- Azure Container Registry
- Azure Kubernetes Service
- Terraform

## Estructura

```text
.
├── .github/workflows/ci-cd.yml
├── Dockerfile
├── docker-compose.yml
├── k8s/
├── terraform/
├── docs/architecture.md
├── scripts/local-test.sh
├── index.js
├── users/
├── shared/
└── README.md
```

## Ejecutar localmente

```bash
cp .env.example .env
npm ci
npm run start
```

Validar:

```bash
curl http://localhost:8000/health
curl http://localhost:8000/api/users
```

## Pruebas, coverage y análisis estático

```bash
npm run lint
npm run test:coverage
```

El coverage queda en la carpeta `coverage/`.

## Docker

La imagen usa Node Alpine, usuario no root, variables de entorno, puerto configurable y healthcheck.

```bash
docker build -t demo-devops-nodejs:local .
docker run --rm -p 8000:8000 demo-devops-nodejs:local
```

Con Docker Compose:

```bash
docker compose up --build
```

## Kubernetes

Manifests incluidos:

- Namespace
- ConfigMap
- Secret
- Deployment con 2 réplicas
- Service
- Ingress
- HPA

Antes de desplegar, cambia la imagen en `k8s/deployment.yaml` o deja que el pipeline la reemplace automáticamente.

```bash
kubectl apply -k k8s/
kubectl get pods -n devsu-demo
kubectl rollout status deployment/demo-devops-nodejs -n devsu-demo
```

## Crear infraestructura en Azure con Terraform

Requisitos:

```bash
az login
az account set --subscription "<subscription-id>"
```

Crear recursos:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

Terraform crea:

- Resource Group
- Azure Container Registry
- AKS con 2 nodos
- Role Assignment para que AKS pueda descargar imágenes del ACR

Ver salidas:

```bash
terraform output
```

## Secrets requeridos en GitHub Actions

Configurar en el repositorio: `Settings > Secrets and variables > Actions`.

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
ACR_NAME
ACR_LOGIN_SERVER
AKS_RESOURCE_GROUP
AKS_NAME
```

Recomendado usar federated credentials/OIDC en Azure para no guardar secretos tipo password.

## Pipeline CI/CD

Archivo: `.github/workflows/ci-cd.yml`

Pasos implementados:

1. Checkout del código.
2. Instalación de dependencias.
3. Análisis estático con ESLint.
4. Unit tests con Jest.
5. Code coverage.
6. Publicación del artifact de coverage.
7. Docker build.
8. Vulnerability scan con Trivy.
9. Docker push a Azure Container Registry.
10. Despliegue a AKS con `kubectl apply -k k8s/`.
11. Validación con `kubectl rollout status`.

## Endpoints

Healthcheck:

```text
GET /health
```

Usuarios:

```text
GET /api/users
GET /api/users/:id
POST /api/users
```

Ejemplo de creación:

```bash
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni":"001","name":"Marino"}'
```

## Decisiones técnicas

- Se eligió Node.js porque el starter project ya trae pruebas base y la app es simple de containerizar.
- Se agregó `/health` para Docker y Kubernetes probes.
- Se cambió el puerto a variable `PORT` para facilitar despliegues.
- Se mantiene SQLite por ser parte del starter, pero en producción real se recomienda Azure SQL, PostgreSQL o un volumen persistente.
- Se usa `replicas: 2` para cumplir alta disponibilidad mínima solicitada.
- Se incluyen ConfigMap y Secret para separar configuración sensible y no sensible.
- Trivy queda como vulnerability scan opcional dentro del pipeline.

## Comandos rápidos para evidencia

```bash
npm run lint
npm run test:coverage
docker build -t demo-devops-nodejs:local .
docker run --rm -p 8000:8000 demo-devops-nodejs:local
kubectl apply -k k8s/
kubectl get all -n devsu-demo
```

## URL pública

Cuando el Ingress tenga DNS configurado, colocar aquí la URL pública:

```text
https://demo-devops.example.com
```

Si no se expone públicamente, adjuntar capturas del pipeline, pods, service, logs y pruebas de healthcheck como evidencia.

## Configuración lista para Azure/GitHub

Valores configurados en el pipeline:

- Subscription ID: `fdecfec5-39cb-46d5-98a4-719bee2207b3`
- Tenant ID: `f9bc3a06-fdd2-4aed-a334-158e495f7245`
- App Client ID: `4635542b-8529-4ad2-8ffe-64ee73dd6cdd`
- Resource Group: `rg-devsu-devops-demo`
- Región: `eastus`
- ACR: `acrdevsufdecfec5`
- AKS: `aks-devsu-devops-demo`

El único valor que debes crear manualmente en GitHub es el secret `AZURE_CREDENTIALS`. El formato está en `github-secrets-setup.md`.

> Importante: no subas el client secret al repositorio público.

## Deployment real en Azure usando GitHub Actions

Este repo quedó configurado para desplegar la aplicación Node.js del ZIP original en Azure.

### Recursos que crea automáticamente

- Resource Group: `rg-devsu-devops-demo`
- Azure Container Registry: `acrdevsufdecfec5`
- AKS: `aks-devsu-devops-demo`
- Terraform remote state:
  - RG: `rg-devsu-tfstate`
  - Storage Account: `sttfdevsufdecfec5`
  - Container: `tfstate`

### Antes de correr el pipeline

Crea el secret `AZURE_CREDENTIALS` en GitHub. Ver `github-secrets-setup.md`.

### Cómo correrlo

1. Sube este proyecto a un repo de GitHub.
2. Crea el secret `AZURE_CREDENTIALS`.
3. Haz push a `main` o ejecuta `workflow_dispatch` manualmente.
4. El pipeline hará tests, coverage, Terraform, build Docker, scan Trivy, push a ACR y deploy a AKS.
5. Al final revisa el paso `Show public endpoint` para obtener la IP pública del servicio.

### Probar la app

Cuando Azure asigne IP pública al LoadBalancer:

```bash
curl http://EXTERNAL-IP/api/users
```
