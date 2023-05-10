SeoulTech-Capston-Design
====

HA Vault Cluster
---
Vault Cluster 는 Google KMS 를 사용하여 민감정보를 안전하게 GCS(Google Cloud Storage)에 저장하며 auto-unsealed 을 통해 데이터를 가져올 수 있습니다.

### Components
**Packer**
: 클러스터에서 사용할 GCP VM Image 를 생성하는 스크립트  

**Terraform**
: 고가용성 Vault 클러스터를 배포할 스크립트


### Deploying Vault
- Packer image 생성
```
cd packer
packer build vault.json
```

- Terraform 실행
```
terraform init
terraform plan
terraform apply --auto-approve
```