# 🚀 n8n Kubernetes Deployment

[![n8n](https://img.shields.io/badge/n8n-Workflow%20Automation-blue?style=for-the-badge&logo=n8n)](https://n8n.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Production%20Ready-blue?style=for-the-badge&logo=kubernetes)](https://kubernetes.io)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

Bu proje, **n8n workflow automation tool**'unu Kubernetes üzerinde, **scalable ve production-ready** bir yapıda (Main + Worker) deploy etmek için gerekli konfigürasyon dosyalarını içerir. Infrastructure olarak database için PostgreSQL ve queue management için Redis kullanılmaktadır.

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

| Directory | Açıklama |
|-----------|----------|
| **n8n/** | n8n uygulamasının main ve worker Deployment'ları, Service'leri, ConfigMap ve Secret dosyaları |
| **postgres/** | PostgreSQL database'i için StatefulSet, Service ve ConfigMap dosyaları |
| **redis/** | Redis queue service için StatefulSet ve Service dosyaları |

```
📦 N8N-KUBERNETES
├── �� n8n/
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
└── README.md                        (Bu dosya)
```

---

## ✅ Prerequisites

- ✔️ Çalışan bir Kubernetes cluster (v1.20+)
- ✔️ `kubectl` command-line tool yapılandırılmış
- ✔️ Default StorageClass mevcut (Persistent Volumes için)
- ✔️ (Opsiyonel) Ingress Controller veya Gateway API desteği

---

## 🚀 Quick Start

### 1️⃣ Namespace Creation

```bash
kubectl create namespace n8n
```

### 2️⃣ Database (PostgreSQL) Setup

```bash
# ConfigMap, Service ve StatefulSet'i apply edin
kubectl apply -f postgres/postgresql-cm.yaml
kubectl apply -f postgres/postgresql-svc.yaml
kubectl apply -f postgres/postgresql-sts.yaml

# PostgreSQL pod'unun hazır olmasını kontrol edin (1-2 dakika)
kubectl wait --for=condition=ready pod -l app=postgres -n n8n --timeout=300s
```

### 3️⃣ Redis Setup

```bash
# Service ve StatefulSet'i apply edin
kubectl apply -f redis/redis-svc.yaml
kubectl apply -f redis/redis-sts.yaml

# Redis pod'unun hazır olmasını kontrol edin
kubectl wait --for=condition=ready pod -l app=redis -n n8n --timeout=300s
```

### 4️⃣ n8n Configuration & Deployment

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

# n8n pod'larının hazır olmasını kontrol edin
kubectl wait --for=condition=ready pod -l app=n8n-main -n n8n --timeout=300s
```

### 5️⃣ Expose (Ingress/Route)

```bash
# HTTPRoute'u apply edin
kubectl apply -f n8n/n8n-httproute.yaml

# veya HTTPS için:
# kubectl apply -f n8n/n8n-httpsroute.yaml
```

### 6️⃣ (Opsiyonel) Auto-scaling Etkinleştir

```bash
kubectl apply -f n8n/n8n-worker-hpa.yaml
```

---

## 📋 Configuration Details

### 🔧 n8n ConfigMap (`n8n/n8n-cm.yaml`)

| Variable | Değer | Açıklama |
|----------|-------|----------|
| **DB_TYPE** | postgresdb | Database type |
| **EXECUTIONS_MODE** | queue | Queue tabanlı execution (worker desteği) |
| **N8N_HOST** | n8n-test.app.setur.software | n8n'in serve edeceği domain |
| **N8N_PROTOCOL** | https | Protokol (https/http) |
| **N8N_SECURE_COOKIE** | true | Secure cookie kullan |
| **GENERIC_TIMEZONE** | Europe/Istanbul | Timezone ayarı |

### 🔐 n8n Secret (`n8n/n8n-secret.yaml`)

> ⚠️ **ÖNEMLİ:** Production ortamında bu değerleri güvenli şekilde yönetin!

| Secret | Açıklama |
|--------|----------|
| **N8N_ENCRYPTION_KEY** | Sensitive data encryption key |
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
- **Auto-scaling:** HPA ile CPU %80 üzerine çıktığında scale up

### Redis
- **Memory Limit:** 512Mi
- **Max Memory Policy:** allkeys-lru (en az kullanılan key'leri sil)

### PostgreSQL
- **Volume:** 10Gi (default)

---

## 🛠️ Useful Commands

```bash
# Tüm namespace'leri kontrol et
kubectl get ns

# n8n namespace'indeki tüm pod'ları görüntüle
kubectl get pods -n n8n -w

# Specific pod'un log'larını görmek
kubectl logs -f deployment/n8n-main -n n8n

# n8n-worker pod'larının log'larını görmek (tüm)
kubectl logs -f deployment/n8n-worker -n n8n --all-containers=true

# Pod'un içine shell ile girmek
kubectl exec -it pod/n8n-main-xxxx -n n8n -- /bin/bash

# Resource kullanımını kontrol et
kubectl top pods -n n8n

# Deployment'ı scale etmek
kubectl scale deployment n8n-worker --replicas=4 -n n8n

# ConfigMap'i update etmek
kubectl edit configmap n8n-config -n n8n

# Secret'ı kontrol etmek
kubectl get secret n8n-secret -n n8n -o yaml

# Tüm resource'ları silmek
kubectl delete namespace n8n
```

---

## ⚙️ Important Notes

### 💾 Persistence
PostgreSQL ve n8n deployment'ları `VolumeClaimTemplate` veya `PersistentVolumeClaim` kullanmaktadır. Cluster'ınızda **default bir StorageClass** olduğundan emin olun:

```bash
kubectl get storageclasses
```

### 📈 Worker Scaling
Worker sayısını artırmak için:

```bash
# Manual scaling
kubectl scale deployment n8n-worker --replicas=5 -n n8n

# Veya `n8n-worker-hpa.yaml` ile Horizontal Pod Autoscaler kullanın
kubectl apply -f n8n/n8n-worker-hpa.yaml
kubectl get hpa -n n8n
```

### 🔒 Security Best Practices

- ✔️ Secret'ları Kubernetes Secrets yerine external secret management tools ile yönetin (Vault, etc.)
- ✔️ Network Policies ile pod iletişimini kısıtlayın
- ✔️ RBAC (Role-Based Access Control) yapılandırın
- ✔️ Pod Security Policies etkinleştirin

### 🚨 Troubleshooting

**Pod'lar pending durumda kalmışsa:**
```bash
kubectl describe pod <pod-name> -n n8n
```

**Database connection hatası:**
```bash
kubectl logs deployment/n8n-main -n n8n | grep -i "database\|connection"
```

**Redis queue issues:**
```bash
kubectl exec -it pod/redis-0 -n n8n -- redis-cli INFO
```

---

## 📚 Resources

- 📖 [n8n Documentation](https://docs.n8n.io)
- 📖 [Kubernetes Documentation](https://kubernetes.io/docs)
- 📖 [PostgreSQL on Kubernetes](https://www.postgresql.org)
- 📖 [Redis on Kubernetes](https://redis.io)

---

## 📝 License

MIT License - Detaylar için LICENSE dosyasına bakın.

---

**Last Updated:** December 2025 | **Version:** 1.0

