# N8N Helm Chart

Bu Helm chart, N8N workflow automation platformunu Kubernetes üzerinde kurmanızı sağlar.

## Kurulum

```bash
# values.yaml dosyasını düzenleyin
vim values.yaml

# Helm chart'ı kurun
helm install n8n . -f values.yaml -n n8n --create-namespace
```

## Özelleştirme

values.yaml dosyasında sadece özelleştirmeniz gereken alanlar bulunmaktadır. Diğer tüm değerler için default değerler kullanılır.

### Zorunlu Özelleştirmeler

Aşağıdaki değerleri **mutlaka** değiştirmelisiniz:

```yaml
# PostgreSQL şifreleri
postgresql:
  auth:
    username: "n8n"
    password: "güçlü-şifre-buraya"  # ÖNEMLİ: Değiştirin!
    database: "n8n"

# N8N secret key'leri
n8n:
  secret:
    encryptionKey: "your-super-secret-encryption-key"  # ÖNEMLİ: Değiştirin!
    dbPassword: "güçlü-şifre-buraya"  # postgresql.auth.password ile aynı olmalı
  
  # Domain yapılandırması
  config:
    host: "n8n.your-domain.com"  # ÖNEMLİ: Domain adınızı girin
    protocol: "https"
    webhookUrl: "https://n8n.your-domain.com"  # ÖNEMLİ: Domain adınızı girin
```

### İsteğe Bağlı Özelleştirmeler

#### N8N Ayarları

Timezone, execution kayıt ayarları gibi N8N'e özel ayarları yapabilirsiniz:

```yaml
n8n:
  config:
    timezone: "Europe/Istanbul"  # Türkiye saati
    executionsDataSaveOnSuccess: "all"  # Başarılı execution'ları da kaydet
    executionsDataMaxAge: "720"  # 30 gün sakla (varsayılan: 14 gün)
```

#### Ingress Kullanımı

```yaml
ingress:
  enabled: true
  className: "nginx"
  host: "n8n.your-domain.com"
```

#### Gateway API Kullanımı

```yaml
gateway:
  enabled: true
  name: "http-gateway"
  namespace: "default"
  host: "n8n.gw.your-domain.com"
```

#### Autoscaling (HPA)

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
```

#### Backup Yapılandırması

Backup'ı aktif etmek için `backup.enabled: true` yapın ve bir storage seçeneği seçin:

**Seçenek 1: PersistentVolume (Local/Default)**
```yaml
backup:
  enabled: true
  schedule: "0 2 * * *"  # Her gün saat 02:00
  storage:
    persistentVolume:
      enabled: true
      size: 5Gi
      # storageClassName: "fast-ssd"  # Opsiyonel
```

**Seçenek 2: AWS S3**
```yaml
backup:
  enabled: true
  storage:
    persistentVolume:
      enabled: false  # PVC'yi kapat
    s3:
      enabled: true
      region: "us-east-1"
      bucket: "my-n8n-backups"
      secretName: "aws-s3-credentials"
```

Secret oluşturun:
```bash
kubectl create secret generic aws-s3-credentials \
  --from-literal=accessKey=YOUR_ACCESS_KEY \
  --from-literal=secretKey=YOUR_SECRET_KEY \
  -n n8n
```

**Seçenek 3: MinIO (Self-hosted S3)**
```yaml
backup:
  enabled: true
  storage:
    persistentVolume:
      enabled: false
    minio:
      enabled: true
      endpoint: "https://minio.example.com"
      bucket: "n8n-backups"
      secretName: "minio-credentials"
```

**Seçenek 4: Azure Blob Storage**
```yaml
backup:
  enabled: true
  storage:
    persistentVolume:
      enabled: false
    azure:
      enabled: true
      container: "n8n-backups"
      secretName: "azure-storage-credentials"
```

**Seçenek 5: NFS**
```yaml
backup:
  enabled: true
  storage:
    persistentVolume:
      enabled: false
    nfs:
      enabled: true
      server: "nfs.example.com"
      path: "/exports/n8n-backups"
```

## Default Değerler

Chart, aşağıdaki default değerlerle gelir (values.yaml'da belirtmenize gerek yoktur):

- **N8N Image**: `n8nio/n8n:latest`
- **PostgreSQL**: Version 13, 5Gi storage
- **Redis**: Version 6.2, 1Gi storage
- **N8N Main**: 1 replica, 5Gi storage
- **N8N Worker**: 1 replica
- **Service Type**: ClusterIP
- **Port**: 5678

Tüm default değerler `templates/_helpers.tpl` dosyasında tanımlanmıştır.

## Notlar

- PostgreSQL ve Redis, StatefulSet olarak deploy edilir
- N8N main ve worker, Deployment olarak deploy edilir
- Default olarak persistence aktiftir
- Health check'ler önceden yapılandırılmıştır

## Upgrade

```bash
helm upgrade n8n . -f values.yaml -n n8n
```

## Uninstall

```bash
helm uninstall n8n -n n8n
```
