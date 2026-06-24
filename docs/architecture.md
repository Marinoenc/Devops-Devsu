# Arquitectura

Flujo de entrega:

Developer -> GitHub -> GitHub Actions -> Tests/Lint/Coverage -> Docker Build -> Trivy Scan -> Azure Container Registry -> AKS -> Service/Ingress.

Componentes:

- Aplicación Node.js Express con SQLite.
- Imagen Docker ejecutando con usuario no root.
- Azure Container Registry para almacenar imágenes.
- AKS con mínimo 2 réplicas y HPA.
- ConfigMap para configuración no sensible.
- Secret para credenciales.
- Probes `/health` para readiness/liveness.

Diagrama simple:

```text
+-----------+      +----------------+      +-----+      +-----+
| Developer | ---> | GitHub Actions | ---> | ACR | ---> | AKS |
+-----------+      +----------------+      +-----+      +-----+
                         |                              |
                         v                              v
                  Tests / Scan                 Pods x2 + Service + Ingress
```
