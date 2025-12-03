# n8n Kubernetes Deployment

Bu proje, n8n workflow automation tool'unu Kubernetes üzerinde, scalable bir yapıda (Main + Worker) deploy etmek için gerekli konfigürasyon dosyalarını içerir. Infrastructure olarak database için PostgreSQL ve queue management için Redis kullanılmaktadır.

## Directory Structure

Proje aşağıdaki ana directory'lerden oluşmaktadır:

- **n8n/**: n8n uygulamasının main ve worker Deployment'ları, Service'leri, ConfigMap ve Secret dosyaları.
- **postgres/**: PostgreSQL database'i için StatefulSet, Service ve ConfigMap dosyaları.
- **redis/**: Redis için StatefulSet ve Service dosyaları.

## Prerequisites

- Çalışan bir Kubernetes cluster.
- `kubectl` command-line tool yapılandırılmış olmalı.
- (Opsiyonel) Ingress Controller veya Gateway API desteği (Route dosyaları için).

## Installation Steps

Kurulumu aşağıdaki sırayla gerçekleştirmeniz önerilir.

### 1. Namespace Creation

Tüm resource'lar `n8n` namespace'i altında çalışacak şekilde yapılandırılmıştır. Öncelikle bu namespace'i oluşturun:

```bash
kubectl create namespace n8n
```

### 2. Database (PostgreSQL) Setup

PostgreSQL database'ini deploy etmek için aşağıdaki komutları çalıştırın:

```bash
# ConfigMap, Service ve StatefulSet'i apply edin
kubectl apply -f postgres/postgresql-cm.yaml
kubectl apply -f postgres/postgresql-svc.yaml
kubectl apply -f postgres/postgresql-sts.yaml
```

### 3. Redis Setup

Redis'i deploy etmek için:

```bash
# Service ve StatefulSet'i apply edin
kubectl apply -f redis/redis-svc.yaml
kubectl apply -f redis/redis-sts.yaml
```

### 4. n8n Configuration & Deployment

n8n uygulamasını (Main ve Worker modülleri) deploy etmek için:

```bash
# ConfigMap ve Secret'ları apply edin
kubectl apply -f n8n/n8n-cm.yaml
kubectl apply -f n8n/n8n-secret.yaml

# Service'leri oluşturun
kubectl apply -f n8n/n8n-svc.yaml
kubectl apply -f n8n/n8n-main-svc.yaml

# Deployment'ları apply edin
kubectl apply -f n8n/n8n-main-deployment.yaml
kubectl apply -f n8n/n8n-worker-deployment.yaml
```

### 5. Expose (Ingress/Route)

Environment'ınıza uygun olan route konfigürasyonunu apply edin (Örnek olarak HTTPRoute):

```bash
kubectl apply -f n8n/n8n-httproute.yaml
# veya HTTPS için
# kubectl apply -f n8n/n8n-httpsroute.yaml
```

## Configuration Details

### n8n ConfigMap (`n8n/n8n-cm.yaml`)
- **DB_TYPE**: Database type (postgresdb).
- **EXECUTIONS_MODE**: `queue` olarak ayarlanmıştır, bu sayede worker'lar kullanılabilir.
- **N8N_HOST**: n8n'in serve edeceği domain adresi.

### n8n Secret (`n8n/n8n-secret.yaml`)
- **N8N_ENCRYPTION_KEY**: Sensitive data encryption key.
- **DB_POSTGRESDB_PASSWORD**: Database connection password.

## Notes

- **Persistence:** PostgreSQL ve n8n deployment'ları `VolumeClaimTemplate` veya `PersistentVolumeClaim` kullanmaktadır. Cluster'ınızda default bir StorageClass olduğundan emin olun.
- **Worker Scaling:** `n8n-worker-deployment.yaml` dosyasındaki `replicas` değerini artırarak worker sayısını scale edebilirsiniz. Ayrıca `n8n-worker-hpa.yaml` dosyası ile Horizontal Pod Autoscaler (HPA) yapılandırılabilir.

```bash
kubectl apply -f n8n/n8n-worker-hpa.yaml
```
