# DevOps Prueba Técnica - Node.js + Docker + Kubernetes + Azure

Proyecto basado en la aplicación `demo-devops-nodejs`, preparado para demostrar un flujo DevOps completo usando Node.js, Docker, GitHub Actions, Azure Container Registry, Azure Kubernetes Service y Terraform.

## URL pública

La aplicación está desplegada y disponible en:

```text
https://api.coinsfree.us/health
```

Endpoint de validación:

```bash
curl https://api.coinsfree.us/health
```

## Stack usado

* Node.js 18
* Express
* SQLite
* Jest + Supertest
* ESLint
* Docker
* GitHub Actions
* Azure Container Registry
* Azure Kubernetes Service
* Terraform
* Kubernetes Ingress
* Trivy

## Estructura del proyecto

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

## Ejecución local

```bash
cp .env.example .env
npm ci
npm run start
```

Validar la aplicación:

```bash
curl http://localhost:8000/health
curl http://localhost:8000/api/users
```

## Pruebas, coverage y análisis estático

```bash
npm run lint
npm run test:coverage
```

El reporte de cobertura se genera en:

```text
coverage/
```

## Docker

La imagen se construyó siguiendo buenas prácticas:

* Imagen base Node Alpine.
* Usuario no root.
* Variables de entorno.
* Puerto configurable.
* Healthcheck incluido.
* Separación de dependencias y runtime.

Construir imagen:

```bash
docker build -t demo-devops-nodejs:local .
```

Ejecutar contenedor:

```bash
docker run --rm -p 8000:8000 demo-devops-nodejs:local
```

Ejecutar con Docker Compose:

```bash
docker compose up --build
```

## Kubernetes

Los manifiestos se encuentran en la carpeta `k8s/` e incluyen:

* Namespace
* ConfigMap
* Secret
* Deployment
* Service
* Ingress
* Horizontal Pod Autoscaler (HPA)

Desplegar:

```bash
kubectl apply -k k8s/
```

Validar despliegue:

```bash
kubectl get pods -n devsu-demo
kubectl get svc -n devsu-demo
kubectl get ingress -n devsu-demo
kubectl rollout status deployment/demo-devops-nodejs -n devsu-demo
```

## Endpoints de la API

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

Ejemplo de creación de usuario:

```bash
curl -X POST https://api.coinsfree.us/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni":"001","name":"Marino"}'
```

## CI/CD con GitHub Actions

El pipeline se encuentra en:

```text
.github/workflows/ci-cd.yml
```

Flujo implementado:

1. Checkout del código.
2. Instalación de dependencias.
3. Análisis estático con ESLint.
4. Ejecución de pruebas unitarias.
5. Generación de reporte de cobertura.
6. Publicación del artifact de coverage.
7. Construcción de imagen Docker.
8. Escaneo de vulnerabilidades con Trivy.
9. Push de imagen a Azure Container Registry.
10. Despliegue en Azure Kubernetes Service.
11. Validación del rollout en Kubernetes.

## Infraestructura en Azure

La infraestructura es desplegada mediante Terraform y está compuesta por:

* Azure Resource Group
* Azure Container Registry (ACR)
* Azure Kubernetes Service (AKS)
* Role Assignments para integración AKS ↔ ACR
* Backend remoto para Terraform State

Los nombres de recursos y configuraciones específicas del entorno se parametrizan mediante variables de Terraform y secretos de GitHub Actions.

> Por motivos de seguridad no se publican identificadores de suscripción, tenant, aplicaciones ni nombres específicos de recursos en el repositorio.

## Ejecutar Terraform

```bash
az login

cd terraform

cp terraform.tfvars.example terraform.tfvars

terraform init
terraform fmt
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

Ver salidas:

```bash
terraform output
```

## Terraform Remote State

El estado de Terraform se almacena en Azure utilizando:

* Azure Storage Account
* Blob Container dedicado para el archivo de estado
* Bloqueo y control de versiones del estado

Esto permite colaboración segura entre múltiples operadores y pipelines CI/CD.

## Secrets requeridos en GitHub Actions

Configurar en:

```text
Settings > Secrets and variables > Actions
```

Secret requerido:

```text
AZURE_CREDENTIALS
```

El formato se encuentra documentado en:

```text
github-secrets-setup.md
```

> Importante: no subir credenciales, secretos ni tokens al repositorio público.

## Despliegue automatizado

Para ejecutar el despliegue:

1. Subir el proyecto a GitHub.
2. Configurar el secret `AZURE_CREDENTIALS`.
3. Realizar un push a la rama `main` o ejecutar manualmente el workflow.
4. El pipeline ejecutará:

   * Lint
   * Tests
   * Coverage
   * Terraform
   * Docker Build
   * Trivy Scan
   * Docker Push
   * Deploy a AKS
5. Validar la aplicación mediante la URL pública.

## Validación de la aplicación

Health Check:

```bash
curl https://api.coinsfree.us/health
```

Respuesta esperada:

```json
{
  "status": "ok"
}
```

## Decisiones técnicas

* Se utilizó Node.js porque el starter project ya incluía una estructura simple y mantenible.
* Se agregó el endpoint `/health` para validación desde Docker, Kubernetes y balanceadores.
* El puerto de escucha se parametrizó mediante variables de entorno.
* Se mantuvo SQLite para respetar el alcance original de la prueba.
* En un entorno productivo se recomienda Azure SQL o PostgreSQL administrado.
* Se configuraron múltiples réplicas para alta disponibilidad básica.
* Se separó la configuración mediante ConfigMaps y Secrets.
* Se incorporó Trivy para análisis de vulnerabilidades de la imagen.
* Se automatizó todo el ciclo de vida de despliegue mediante GitHub Actions.

## Comandos útiles para evidencia

```bash
npm run lint

npm run test:coverage

docker build -t demo-devops-nodejs:local .

docker run --rm -p 8000:8000 demo-devops-nodejs:local

kubectl apply -k k8s/

kubectl get all -n devsu-demo

kubectl logs -n devsu-demo deployment/demo-devops-nodejs

kubectl rollout status deployment/demo-devops-nodejs -n devsu-demo

curl https://api.coinsfree.us/health
```

## Estado final

La solución implementa:

* Dockerización de la aplicación.
* Pipeline CI/CD automatizado.
* Pruebas unitarias.
* Reportes de cobertura.
* Análisis estático de código.
* Escaneo de vulnerabilidades.
* Construcción y publicación de imágenes Docker.
* Despliegue automatizado en Kubernetes.
* Infraestructura como código mediante Terraform.
* Documentación técnica completa.
* Exposición pública mediante Ingress.

## URL Final

```text
https://api.coinsfree.us/health
```
