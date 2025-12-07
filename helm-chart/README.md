# n8n Helm Chart

## Installation

```bash
helm install n8n ./helm-chart -n n8n --create-namespace
```

## Upgrade

```bash
helm upgrade n8n ./helm-chart -n n8n
```

## Uninstall

```bash
helm uninstall n8n -n n8n
```

## Custom Values

```bash
helm install n8n ./helm-chart -n n8n --create-namespace -f custom-values.yaml
```

## Configuration

All configuration options are available in `values.yaml`

### Key Configuration Options

- `namespace`: Kubernetes namespace
- `postgresql.*`: PostgreSQL database settings
- `redis.*`: Redis cache and queue settings
- `n8n.main.*`: n8n main instance configuration
- `n8n.worker.*`: n8n worker instances configuration
- `n8n.config.*`: n8n application settings
- `n8n.secret.*`: Sensitive credentials (base64 encoded)
- `ingress.*`: Ingress/Gateway configuration
- `autoscaling.*`: HPA settings for workers
