Secret Management with Vault
=========
## Identity
| Role | Agent | Auth Method | Policies |
| ------ | ------ | ------ | ------ |
| operator | User | OIDC | default <br> operator |
| iise-argocd-dev-deployer | System | AppRole | iise-argocd-dev-deployer |
| iise-argocd-prod-deployer | System | AppRole | iise-argocd-prod-deployer |
| iise-github-deployer | System | AppRole | iise-github-deployer |
| itm-argocd-dev-deployer | System | AppRole | itm-argocd-dev-deployer |
| itm-argocd-prod-deployer | System | AppRole | itm-argocd-prod-deployer |
| itm-github-deployer | System | AppRole | itm-github-deployer |

### Role & Policy
**Convention**
- Role : {부서}-{사용처}-{OPTIONAL : 개발환경}-{역할}
- Policy : Role 과 동일하게 간다.

**Policy**
- 스크립트로 policy 일괄 적용
    ```bash
    ./init-policies.sh \                                                                                                                                       ──(Mon,May08)─┘
        -t {VAULT_TOKEN} \
        -n {iise | itm} \
        -a {https://VAULT_ADDR:8200}
    ```
- Capability

  | Capability | Associated HTTP verbs |
    | ------ | ------ |
  | create | POST/PUT |
  | read | GET |
  | update | POST/PUT |
  | delete | DELETE |
  | list | LIST |
  | sudo | The sudo capability allows access to paths that are root-protected (Refer to the Root protected endpoints section). |
  | deny | The deny capability disables access to the path. When combined with other capabilities it always precedence. |


## Secret
### Secret Engine
**NAMESPACE** | **REPOSITORY**
- iise | iise-backend, iise-frontend
- itm | itm-backend, itm-frontend

**Path** :
- Github : CI - Github Action Workflow 에서 필요한 시크릿
    ```
    admin/{NAMESPACE}/github/data/{REPOSITORY}
    ```
- GKE : CD - Kubernetes Container Runtime 시 필요한 시크릿
    ```
    admin/{NAMESPACE}/gke/{ENV}/data/{KUBERNETES_SECRET}
    ```

## Example
- 자주 사용하는 커맨드
    ```
    # 항상 실행 전에 환경변수를 EXPORT 한다.
    export VAULT_ADDR=
    export VAULT_TOKEN=
    export VAULT_NAMESPACE=admin/{NAMESPACE}
    
    # Secret Engine 데이터 조회
    vault read github/data/{REPOSITORY}
    vault read gke/data/{K8S_SECRET}
    
    # Auth Method 확인
    vault auth list
    
    # Auth Method 활성화/비활성화
    vault auth enable {AUTH_METHOD}
    vault auth disable {AUTH_METHOD}
    
    
    # Role 정보 확인
    vault list auth auth/{AUTH_METHOD}/role
    vault read auth/{AUTH_METHOD}/role/{ROLE_NAME}
    
    # Auth Method 가 AppRole 방식일 경우 ROLE-ID 를 체크한다.
    vault read auth/approle/role/{ROLE_NAME}/role-id
    
    # Policy 조회
    vault policy list
    vault policy read {POLICY}
  
    # Policy 생성
    vault policy write {POLICY} {POLICY_FILE}.hcl
    
  
    # Policy 를 가진 10분 간 유효한 VAULT_TOKEN 발행
    vault token create -policy="{POLICY}" -ttl=10m
    
    # VAULT_TOKEN 갱신
    vault token renew {VAULT_TOKEN}
  
    # VAULT_TOKEN 회수
    vault token revoke {VAULT_TOKEN}
  
    ```


- Auth Method 등록 시나리오
    ```bash
    # Example
    vault write -ns=admin/{NAMESPACE} auth/oidc/config \
       oidc_discovery_url="https://accounts.google.com" \
       oidc_client_id="{OIDC_CLIENT_ID}" \
       oidc_client_secret="{OIDC_CLIENT_SECRET}" \
       default_role="default"
    ```
    - OIDC 클라이언트 정보 확인 : GCP **prj-d-devops** -> API 및 서비스 -> 사용자 인증 정보

- OIDC로 인증할 Role 설정
    ```bash
    # Example
    vault write -ns=admin/{NAMESPACE} auth/oidc/role/{ROLE_NAME} -<<EOF
    {
        "role_type": "oidc",
        "user_claim": "email",
        "bound_audiences": "{OIDC_CLIENT_ID}",
        "allowed_redirect_uris": [
          "https://{VAULT_ADDR}:8200/ui/vault/auth/oidc/oidc/callback"
          "https://{VAULT_ADDR}:8250/oidc/callback"
        ],
        "oidc_scopes": ["openid","email","profile"],
        "user_claim_json_pointer": "true",
        "bound_claims": {
          "email": [
            "{USER_LOGIN_EMAIL_0}",
            "{USER_LOGIN_EMAIL_1}"
          ]
        },
        "policies": [
          "{POLICY_0}", 
          "{POLICY_1}"
          "{POLICY_2}"
        ],
        "ttl": "10m"
    }
    EOF
    ```
