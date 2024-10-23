## Install Vector on K8s using Helm
```
helm repo add vector https://helm.vector.dev
helm repo update
helm install vector vector/vector --namespace vector --create-namespace
```

## Managing Vector
Once Vector is up and running in K8s, you can manage it using kubectl
```
kubectl rollout restart --namespace vector statefulset/vector-aggregator
```

## Uninstall Vector
```
helm uninstall vector --namespace vector
```