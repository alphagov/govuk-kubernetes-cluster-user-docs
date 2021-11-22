# Toolchain Setup
### Overview 
This documentation will show you how to Install tools needed to interact with GOV.UK Kubernetes Cluster.

### Kubectl
To install on macOS you can use brew.
```sh
brew install kubectl
```
Test that kubectl is working.
```sh
kubectl version --client
```
Official guide:
https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/

### HELM
to install helm on macOS you can use brew.
```sh
brew install helm
```
Test Helm is working:
```sh
helm version
```
Official guide:
https://helm.sh/docs/intro/install/

### GDS-CLI and AWS-Vault
gds-cli is needed for us to communicate with AWS using CLI tools
```sh
brew install alphagov/gds/gds-cli
```
Test gds-cli
```sh
gds --version
```
Install aws-vault:
```sh
brew install --cask aws-vault
```
Test aws-vault
```sh
aws-vault --version
```
if you If you get MFA codes from your phone
```sh
gds config yubikey false
```
Official guide:
https://github.com/99designs/aws-vault#readme
https://github.com/alphagov/gds-cli

### Helpful commands
Update kubeconfig
```sh
aws eks update-kubeconfig --name <cluster_name> --region <aws-region>
```
Get all pods running in kubernetes cluster
```sh
kubectl get pods --all-namespaces
```
List all charts deployed using Helm on the cluster
```sh
helm list
```
### Helpful guides
[Kubectl commands & autocompletion setup](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
[Helm commands & autocompletion setup](https://helm.sh/docs/helm/)
