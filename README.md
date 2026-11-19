# 🚀 n8n Kubernetes Deployment

[![n8n](https://img.shields.io/badge/n8n-Workflow%20Automation-blue?style=for-the-badge&logo=n8n)](https://n8n.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Production%20Ready-blue?style=for-the-badge&logo=kubernetes)](https://kubernetes.io)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

A comprehensive Kubernetes deployment configuration for **n8n workflow automation platform** with a scalable architecture (Main + Worker model). This setup uses **PostgreSQL** for data persistence and **Redis** for queue management.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Kubernetes Cluster (n8n namespace)          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────┐                     ┌────────────────────┐   │
│  │  Ingress/Route │                     │  n8n Service       │   │
│  │  (HTTPRoute)   │                     │  (Port: 5678)      │   │
│  └────────┬────────┘                     └────────┬───────────┘   │
│           │                                       │                │
│  ┌────────▼────────────────────────┐             │                │
│  │   n8n Main (Deployment)         │             │                │
│  │   ├─ n8n UI/API (Port 5678)     │──────┬──────┘                │
│  │   └─ Persistent Storage         │      │                       │
│  └─────────────────────────────────┘      │                       │
│                                            │                       │
│  ┌──────────────────────────────────────┐  │                       │
│  │  n8n Workers (Deployment x2+)        │  │                       │
│  │  ├─ Worker 1 (Execution Engine)      │──┼──┐                    │
│  │  ├─ Worker 2 (Execution Engine)      │  │  │                    │
│  │  └─ Auto-scaling with HPA            │  │  │                    │
│  └──────────────────────────────────────┘  │  │                    │
│                                             │  │                    │
│  ┌──────────────────────────────────┐    │  │                    │
│  │  Redis (StatefulSet)              │    │  │                    │
│  │  ├─ Queue Management              │◄───┼──┘                    │
│  │  ├─ Cache (maxmemory: 512Mi)      │    │                       │
│  │  └─ Port: 6379                    │    │                       │
│  └──────────────────────────────────┘    │                       │
│                                           │                       │
│  ┌──────────────────────────────────┐    │                       │
│  │  PostgreSQL (StatefulSet)         │    │                       │
│  │  ├─ Database: n8n                 │◄───┘                       │
│  │  ├─ User: n8n                     │                            │
│  │  ├─ Persistent Storage            │                            │
│  │  └─ Port: 5432                    │                            │
│  └──────────────────────────────────┘                            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Directory Structure

| Directory | Description |
|-----------|-------------|
| **n8n/** | n8n application configurations including Main and Worker Deployments, Services, ConfigMaps, and Secrets |
| **postgres/** | PostgreSQL database configuration files: StatefulSet, Service, and ConfigMap |
| **redis/** | Redis queue service configuration files: StatefulSet and Service |

```
📦 N8N-KUBERNETES
├── 📂 n8n/
│   ├── n8n-cm.yaml                 (ConfigMap: Environment Variables)
│   ├── n8n-secret.yaml             (Secret: Encryption Keys & Credentials)
│   ├── n8n-svc.yaml                (Service: Cluster Internal)
│   ├── n8n-main-svc.yaml           (Service: Main Pod)
│   ├── n8n-main-deployment.yaml    (Deployment: Main Instance)
│   ├── n8n-worker-deployment.yaml  (Deployment: Worker Instances)
│   ├── n8n-worker-hpa.yaml         (HPA: Auto-scaling)
│   ├── n8n-httproute.yaml          (Route: HTTP Ingress)
│   ├── n8n-httpsroute.yaml         (Route: HTTPS Ingress)
│   └── n8n-main-storage.yaml       (PVC: Persistent Volume)
├── 📂 postgres/
│   ├── postgresql-cm.yaml          (ConfigMap: Database Config)
│   ├── postgresql-sts.yaml         (StatefulSet: Database Instance)
│   └── postgresql-svc.yaml         (Service: Database Access)
├── 📂 redis/
│   ├── redis-sts.yaml              (StatefulSet: Redis Instance)
│   └── redis-svc.yaml              (Service: Redis Access)
└── README.md                        (This file)
```

---

## 📦 Helm Chart

This repository includes a Helm chart to simplify the deployment and management of the n8n stack on Kubernetes.

### Chart Structure

```
📦 helm-chart
├── Chart.yaml                  # Chart metadata
├── values.yaml                 # Default configuration values
├── .helmignore                 # Files to ignore when packaging
├── README.md                   # Helm chart README
└── templates/                  # Directory of templates that, when combined with values, will generate valid Kubernetes manifest files
    ├── _helpers.tpl            # Helm helper templates
    ├── namespace.yaml          # Template for the namespace
    ├── n8n-configmap.yaml      # Template for n8n ConfigMap
    ├── n8n-secret.yaml         # Template for n8n Secrets
    ├── n8n-service.yaml        # Template for internal n8n service
    ├── n8n-main-service.yaml   # Template for the main n8n service
    ├── n8n-main-deployment.yaml# Template for the main n8n deployment
    ├── n8n-worker-deployment.yaml# Template for the n8n worker deployment
    ├── n8n-hpa.yaml            # Template for the worker HPA
    ├── n8n-pvc.yaml            # Template for the main persistent volume claim
    ├── n8n-httproute.yaml      # Template for the HTTPRoute
    ├── n8n-httpsroute.yaml     # Template for the HTTPSRoute
    ├── postgresql-statefulset.yaml # Template for PostgreSQL StatefulSet
    ├── postgresql-service.yaml # Template for PostgreSQL Service
    ├── postgresql-configmap.yaml # Template for PostgreSQL ConfigMap
    ├── redis-statefulset.yaml  # Template for Redis StatefulSet
    └── redis-service.yaml      # Template for Redis Service
```

### Installation

To deploy the chart, use the following commands:

1.  **Navigate to the chart directory:**
    ```sh
    cd helm-chart
    ```

2.  **Install the chart:**
    ```sh
    helm install my-n8n . --namespace n8n --create-namespace
    ```
    *Replace `my-n8n` with your desired release name.*

### Configuration

The following table lists the configurable parameters of the n8n chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `namespace` | The namespace to deploy all resources into. | `n8n` |
| `postgresql.enabled` | Enable PostgreSQL deployment. | `true` |
| `postgresql.image.repository` | PostgreSQL image repository. | `postgres` |
| `postgresql.image.tag` | PostgreSQL image tag. | `18.7` |
| `postgresql.database` | PostgreSQL database name. | `n8n` |
| `postgresql.username` | PostgreSQL username. | `n8n` |
| `postgresql.password` | PostgreSQL password. | `PasdN1831c!*n` |
| `postgresql.storage` | Persistent storage size for PostgreSQL. | `10Gi` |
| `redis.enabled` | Enable Redis deployment. | `true` |
| `redis.image.repository` | Redis image repository. | `redis` |
| `redis.image.tag` | Redis image tag. | `8.10.3-alpine` |
| `redis.maxMemory` | Redis max memory. | `512mb` |
| `redis.storage` | Persistent storage size for Redis. | `2Gi` |
| `n8n.image.repository` | n8n image repository. | `docker.n8n.io/n8nio/n8n` |
| `n8n.image.tag` | n8n image tag. | `2.48.6` |
| `n8n.main.enabled` | Enable the main n8n instance. | `true` |
| `n8n.main.replicas` | Number of replicas for the main instance. | `1` |
| `n8n.main.storage` | Persistent storage size for the main instance. | `10Gi` |
| `n8n.worker.enabled` | Enable n8n worker instances. | `true` |
| `n8n.worker.replicas` | Initial number of worker replicas. | `2` |
| `n8n.hpa.enabled` | Enable Horizontal Pod Autoscaler for workers. | `true` |
| `n8n.hpa.minReplicas` | Minimum number of worker replicas. | `2` |
| `n8n.hpa.maxReplicas` | Maximum number of worker replicas. | `5` |
| `n8n.config.dbType` | n8n database type. | `postgresdb` |
| `n8n.config.dbHost` | n8n database host. | `postgres` |

---

## 🚀 Deployment

To deploy the n8n stack, you can apply the Kubernetes manifest files directly.

1.  **Create the namespace:**
    ```sh
    kubectl create namespace n8n
    ```

2.  **Apply the configurations:**
    ```sh
    kubectl apply -f postgres/ -n n8n
    kubectl apply -f redis/ -n n8n
    kubectl apply -f n8n/ -n n8n
    ```

## 🚦 Accessing n8n

Once deployed, you can access the n8n UI. If you are using a local Kubernetes cluster (like Minikube or Docker Desktop), you can port-forward the service:

```sh
kubectl port-forward svc/n8n-main-svc 5678:5678 -n n8n
```

Then, open your browser and go to `http://localhost:5678`.

## ⚙️ Configuration

Key configurations are managed via `ConfigMap` and `Secret` files.

-   **`n8n/n8n-cm.yaml`**: Contains environment variables for n8n, such as database connection details, Redis settings, and execution modes.
-   **`n8n/n8n-secret.yaml`**: Stores sensitive data like the encryption key and database credentials. Remember to **Base64 encode** your secret values.

## ⚖️ License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


### Quick Start with Helm

#### 1️⃣ Install Chart

```bash
helm install n8n ./helm-chart --namespace n8n --create-namespace
```

#### 2️⃣ Upgrade Chart

```bash
helm upgrade n8n ./helm-chart --namespace n8n
```

#### 3️⃣ Uninstall Chart

```bash
helm uninstall n8n --namespace n8n
```

### Customize Configuration

You can customize the deployment by overriding the default values in `values.yaml`. Create a custom `my-values.yaml` file and use it during installation:

```bash
helm install n8n ./helm-chart --namespace n8n --create-namespace -f my-values.yaml
```

### PostgreSQL Backup

The Helm chart includes an optional CronJob to automatically back up the PostgreSQL database. You can enable and configure it in your `my-values.yaml`:

```yaml
backup:
  enabled: true
  schedule: "0 3 * * *" # Daily at 3 AM
  storage:
    # Option 1: Use a new PersistentVolumeClaim
    persistentVolume:
      enabled: true
      size: 10Gi
      storageClassName: "your-storage-class"
      
    # Option 2: Use S3-compatible storage
    # s3:
    #   enabled: true
    #   endpoint: "s3.your-region.amazonaws.com"
    #   bucket: "your-n8n-backups"
    #   secretName: "s3-credentials-secret"

    # Option 3: Use Azure Blob Storage
    # azure:
    #   enabled: true
    #   container: "your-backup-container"
    #   secretName: "azure-storage-secret"
```

---

## Helm Chart Usage

To install the chart with the release name `n8n` in the `n8n` namespace:

```bash
helm install n8n ./helm-chart --namespace n8n --create-namespace
```

### Configuration

The Helm chart is configurable through the `helm-chart/values.yaml` file. You can override default values by providing your own `custom-values.yaml` file during installation.

```bash
helm install n8n ./helm-chart -n n8n --create-namespace -f custom-values.yaml
```

#### Ingress and Gateway API

You can expose n8n using either a standard Ingress or the newer Gateway API. The following parameters can be configured:

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

For more details on the chart's structure and all available configuration options, please refer to the [helm-chart/README.md](helm-chart/README.md).

---

## 🚀 Quick Start

### 1️⃣ Create Namespace

```bash
kubectl create namespace n8n
```

### 2️⃣ Deploy PostgreSQL Database

```bash
# Apply ConfigMap, Service, and StatefulSet
kubectl apply -f postgres/postgresql-cm.yaml
kubectl apply -f postgres/postgresql-svc.yaml
kubectl apply -f postgres/postgresql-sts.yaml

# Wait for PostgreSQL pod to be ready (1-2 minutes)
kubectl wait --for=condition=ready pod -l app=postgres -n n8n --timeout=300s
```

### 3️⃣ Deploy Redis

```bash
# Apply Service and StatefulSet
kubectl apply -f redis/redis-svc.yaml
kubectl apply -f redis/redis-sts.yaml

# Wait for Redis pod to be ready
kubectl wait --for=condition=ready pod -l app=redis -n n8n --timeout=300s
```

### 4️⃣ Configure and Deploy n8n

```bash
# Apply ConfigMap and Secrets
kubectl apply -f n8n/n8n-cm.yaml
kubectl apply -f n8n/n8n-secret.yaml

# Create Services
kubectl apply -f n8n/n8n-svc.yaml
kubectl apply -f n8n/n8n-main-svc.yaml

# Deploy Main and Worker instances
kubectl apply -f n8n/n8n-main-deployment.yaml
kubectl apply -f n8n/n8n-worker-deployment.yaml

# Wait for n8n pods to be ready
kubectl wait --for=condition=ready pod -l app=n8n-main -n n8n --timeout=300s
```

### 5️⃣ Expose with Ingress/Route

```bash
# Apply HTTPRoute
kubectl apply -f n8n/n8n-httproute.yaml

# Or for HTTPS:
# kubectl apply -f n8n/n8n-httpsroute.yaml
```

### 6️⃣ (Optional) Enable Auto-scaling

```bash
kubectl apply -f n8n/n8n-worker-hpa.yaml
```

---

## 📋 Configuration Details

### 🔧 n8n ConfigMap (`n8n/n8n-cm.yaml`)

| Variable | Value | Description |
|----------|-------|-------------|
| **DB_TYPE** | postgresdb | Database type |
| **EXECUTIONS_MODE** | queue | Queue-based execution (enables worker support) |
| **N8N_HOST** | n8n.example.com | Domain where n8n will be served |
| **N8N_PROTOCOL** | https | Protocol (https/http) |
| **N8N_SECURE_COOKIE** | true | Enable secure cookies |
| **GENERIC_TIMEZONE** | Europe/Istanbul | Timezone setting |

### 🔐 n8n Secret (`n8n/n8n-secret.yaml`)

> ⚠️ **IMPORTANT:** Manage these values securely in production!

| Secret | Description |
|--------|-------------|
| **N8N_ENCRYPTION_KEY** | Encryption key for sensitive data |
| **DB_POSTGRESDB_PASSWORD** | Database connection password |

---

## 📊 Pod Resources & Scaling

### n8n Main
- **CPU Request:** 500m | **Limit:** 1000m
- **Memory Request:** 1Gi | **Limit:** 2Gi

### n8n Workers
- **CPU Request:** 250m | **Limit:** 500m
- **Memory Request:** 512Mi | **Limit:** 1Gi
- **Default Replicas:** 2
- **Auto-scaling:** HPA scales up when CPU exceeds 80%

### Redis
- **Memory Limit:** 512Mi
- **Max Memory Policy:** allkeys-lru (evict least recently used keys)

### PostgreSQL
- **Volume:** 10Gi (default)

---

## 🛠️ Useful Commands

```bash
# View all namespaces
kubectl get ns

# Watch all pods in n8n namespace
kubectl get pods -n n8n -w

# View logs from specific pod
kubectl logs -f deployment/n8n-main -n n8n

# View logs from all n8n-worker pods
kubectl logs -f deployment/n8n-worker -n n8n --all-containers=true

# Access pod shell
kubectl exec -it pod/n8n-main-xxxx -n n8n -- /bin/bash

# Check resource usage
kubectl top pods -n n8n

# Scale deployment
kubectl scale deployment n8n-worker --replicas=4 -n n8n

# Edit ConfigMap
kubectl edit configmap n8n-config -n n8n

# View Secret
kubectl get secret n8n-secret -n n8n -o yaml

# Delete all resources
kubectl delete namespace n8n
```

---

## ⚙️ Important Notes

### 💾 Persistence
PostgreSQL and n8n deployments use `VolumeClaimTemplate` or `PersistentVolumeClaim`. Ensure your cluster has a **default StorageClass**:

```bash
kubectl get storageclasses
```

### 📈 Worker Scaling
To increase the number of workers:

```bash
# Manual scaling
kubectl scale deployment n8n-worker --replicas=5 -n n8n

# Or use Horizontal Pod Autoscaler
kubectl apply -f n8n/n8n-worker-hpa.yaml
kubectl get hpa -n n8n
```

### 🔒 Security Best Practices

- ✔️ Use external secret management tools (Vault, AWS Secrets Manager) instead of Kubernetes Secrets
- ✔️ Implement Network Policies to restrict pod-to-pod communication
- ✔️ Configure RBAC (Role-Based Access Control)
- ✔️ Enable Pod Security Policies
- ✔️ Use image pull secrets for private registries

### 🚨 Troubleshooting

**If pods are stuck in Pending state:**
```bash
kubectl describe pod <pod-name> -n n8n
```

**Database connection errors:**
```bash
kubectl logs deployment/n8n-main -n n8n | grep -i "database\|connection"
```

**Redis queue issues:**
```bash
kubectl exec -it pod/redis-0 -n n8n -- redis-cli INFO
```

**Check pod resources:**
```bash
kubectl top pod <pod-name> -n n8n
```

---

## 📚 Resources

- �� [n8n Documentation](https://docs.n8n.io)
- 📖 [Kubernetes Documentation](https://kubernetes.io/docs)
- 📖 [PostgreSQL on Kubernetes](https://www.postgresql.org)
- 📖 [Redis on Kubernetes](https://redis.io)
- 📖 [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

---

## 📝 License

MIT License - See LICENSE file for details.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

**Last Updated:** November 2026 | **Version:** 1.1

