ArgoCD
===
## Structure
```
apps
├── Chart.yaml
├── templates       # Application Template (CRD)
├── test            # Test Template
└── values
    └── henesis     # 팀 별 Value File


infra
├── applicationset-controller           # 컨트롤러
├── dex-server                          # 외부 인증
├── metrics                             # Metric 서버
├── notifications-controller-metrics    # Noti 서버
├── redis                                 
├── repo-server                         # Repository 서버
├── server                              # 실제 ArgoCD 서버
|
├── README.md
├── crd.yaml
├── configmap.dev.yaml
├── configmap.mainnet.yaml
├── install.henesis.dev.sh
├── networkpolicy.yaml
├── rbac.dev.yaml
├── argocd-secret.yaml
└── role.yaml
```

## Deployment
### Infrastructure
- ArgoCD Secret 파일 작성
  - Template
    ```yaml
    # dex.google.clientId/Secret : Google SSO Login 
    # AVP_ROLE_ID/AVP_SECRET_ID : ArgoCD Vault Plugin
    
    apiVersion: v1
    data:
      dex.google.clientId: ""
      dex.google.clientSecret: ""
    stringData:
      webhook.github.secret: "aGVuZXNpcy1hcmdvY2Q=" # henesis-argocd
    kind: Secret
    metadata:
      labels:
        app.kubernetes.io/name: argocd-secret
        app.kubernetes.io/part-of: argocd
      name: argocd-secret
      namespace: argocd
    type: Opaque
    ---
    apiVersion: v1
    data:
      AVP_AUTH_TYPE: YXBwcm9sZQ== # approle
      AVP_ROLE_ID: ""
      AVP_SECRET_ID: ""
      AVP_TYPE: dmF1bHQ= # vault
      VAULT_ADDR: aHR0cHM6Ly9jbHMtbS1kZXZvcHMtdmF1bHQtcHVibGljLXZhdWx0LTY1NDNlZjM5LmE0MGE5MTJmLnoxLmhhc2hpY29ycC5jbG91ZDo4MjAwLw==
      VAULT_NAMESPACE: "YWRtaW4vaGVuZXNpcw==" # admin/henesis
    kind: Secret
    metadata:
      name: argocd-vault-plugin-credentials
      namespace: argocd
    type: Opaque
    ```
  - Secret Update
    ```bash
    # Cluster 권한 획득
    gcloud container clusters get-credentials kc-p-devops-230508 --region asia-northeast3-a --project prj-p-devops
    
    # Apply
    kubectl apply -f {SECRET_FILE}.yaml -n argocd
    ```
    

- Infra 서버 구동
    ```bash
    ./install.{TEAM}.{ENV}.sh
    ```
- ArgoCD DNS 설정
    ```bash
    cd ./server 
    kubectl apply -f ingress.{ENV}.yaml -n argocd
    ```
- ArgoCD 외부 클러스터 추가
    ```bash
    # Example
    
    # 초기 비밀번호 확인 (Base64 인코딩된 값)
    kubectl get secret argocd-initial-admin-secret -n argocd -oyaml
    
    # 어드민 비밀번호 변경
    argocd account update-password --account foobar
    
    # ArgoCD CLI 로 로그인
    argocd login argocd.dev.henesis.io
    # Username : admin
    # Password : {argocd-initial-admin-secret}
  
    # 외부 클러스터 추가 (예시 Henesis Cluster)
    argocd cluster add gke_prj-d-henesis_asia-northeast3-a_kc-d-henesis-230419 --name kc-d-henesis-230419
    ```

### Application
- Github 연동하기 (using GithubPAT)
- Project 생성 및 AllowList 적용
- 어플리케이션 배포
  ```bash
  cd ./apps
  helm upgrade --install {RELEASE_NAME} -f values/{TEAM}/values.{ENV}.yaml .
  ```