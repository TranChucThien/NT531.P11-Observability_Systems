

```bash
kubectl apply -f frontend/frontend-deploy.yaml -f microservices/auth-service-deploy.yaml -f microservices/comment-service-deploy.yaml -f microservices/gateway-deploy.yaml -f microservices/post-service-deploy.yaml -f secret-config/api-configmap.yaml -f secret-config/database-secret.yaml 
```