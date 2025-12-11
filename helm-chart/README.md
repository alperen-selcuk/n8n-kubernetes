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

The following table lists the configurable parameters of the n8n chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `"nginx"` |
| `ingress.host` | Ingress host | `"n8n.example.com"` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `gateway.enabled` | Enable gateway | `false` |
| `gateway.name` | Gateway name | `"http-gateway"` |
| `gateway.namespace` | Gateway namespace | `"default"` |
| `gateway.host` | Gateway host | `"n8n.gw.example.com"` |

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

### Ingress and Gateway API

You can expose n8n using either a standard Ingress or the newer Gateway API.

#### Ingress

To use an Ingress, set `ingress.enabled` to `true` and specify the `ingress.host`.

Example `custom-values.yaml`:

```yaml
ingress:
  enabled: true
  host: "n8n.yourdomain.com"
  className: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 100m
```

This will create an Ingress resource for the specified host.

#### Gateway API

To use the Gateway API, you need a Gateway API controller running in your cluster. Then, set `gateway.enabled` to `true` and specify the `gateway.host`.

Example `custom-values.yaml`:

```yaml
gateway:
  enabled: true
  host: "n8n.gw.yourdomain.com"
  name: "http-gateway"
  namespace: "default"
```

This will create an `HTTPRoute` resource for the specified host, attaching it to the specified gateway.

