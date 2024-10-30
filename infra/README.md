
## Connect AWS CLI to kubectl
```
aws eks update-kubeconfig --region us-east-1 --name production-environment
```

## Deploy app
```
kubectl create ns app

kubectl apply -f microservices/frontend-deploy.yaml -f microservices/auth-service-deploy.yaml -f microservices/comment-service-deploy.yaml -f microservices/gateway-deploy.yaml -f microservices/post-service-deploy.yaml -f secret-config/api-configmap.yaml -f secret-config/database-secret.yaml -n app
```