# Title
This folder store all about how to install and configure Datadog using Helm to monitor K8s cluster infra and services

## File descriptions

- `datadog-values.yaml`: Stores configuration values for deploying Datadog using Helm. This file includes settings for Datadog agents, integrations, and other parameters to customize the monitoring setup.


## Configuration

Instructions on how to install and set up the project.

### Install helm
```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```
### Install Datadog agent
Prepare datadog-values.yaml file
```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
kubectl create secret generic datadog-secret --from-literal api-key=<DATADOG_API_KEY>
//Install Datadog agent
helm install datadog-agent -f datadog-values.yaml datadog/datadog 
```
Verify the installation
```bash
kubectl get pods -l app.kubernetes.io/name=datadog-agent
```

Uninstall Datadog agent
```bash
helm uninstall datadog-agent
```

## Setup
### Install and update AWS CLI
```bash
sudo apt-get update
sudo apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
```

Configure AWS credentials
```bash
mkdir -p ~/.aws
echo "${{ secrets.AWS_CLI_TOKEN }}" > ~/.aws/credentials
```

### Set up kubectl 
Install kubectl
```bash
sudo snap install kubectl --classic
```
Connect to EKS cluster

```bash
#aws eks update-kubeconfig --region us-east-1 --name my-cluster
aws eks update-kubeconfig --region us-east-1 --name production-environment
kubectl get nodes -o wide
```
