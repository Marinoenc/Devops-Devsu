# GitHub Secrets necesarios

En GitHub ve a:

Settings > Secrets and variables > Actions > New repository secret

Crea este secret:

## AZURE_CREDENTIALS

Pega un JSON con este formato:

```json
{
  "clientId": "4635542b-8529-4ad2-8ffe-64ee73dd6cdd",
  "clientSecret": "PEGA_AQUI_EL_SECRET_NUEVO",
  "subscriptionId": "fdecfec5-39cb-46d5-98a4-719bee2207b3",
  "tenantId": "f9bc3a06-fdd2-4aed-a334-158e495f7245"
}
```

Importante: rota el secret que compartiste por chat y usa uno nuevo.
