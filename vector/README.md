## Install Vector on K8s using Helm
```
helm repo add vector https://helm.vector.dev
helm repo update
helm install vector vector/vector --namespace vector --create-namespace -f ./values.yaml
```

## Managing Vector
Once Vector is up and running in K8s, you can restart it using kubectl
```
kubectl rollout restart --namespace vector statefulset/vector-aggregator
```

You can update the config using:
```
helm upgrade vector vector/vector -n vector -f .\values.yaml
```

## Uninstall Vector
```
helm uninstall vector --namespace vector
```