# GOV.UK Kubernetes Cluster User Documentation

## Introduction

## Who is this documentation for?

## Kubernetes overview

## Helm overview

## Tools setup

## Getting access to the cluster
1. Assume the proper IAM role using [gds-cli](https://github.com/alphagov/gds-cli#usage)
2. If it's your first time accessing the cluster through kubectl:
```
aws eks update-kubeconfig --name govuk
```
This will add the govuk cluster to your kubectl configuration in `~/.kube/config`

3. To check that you have access, run:
```
kubectl cluster-info
```
If you have access this should return information about the govuk EKS cluster control plane, it should look like this:
```
Kubernetes control plane is A115198D15A398EB0BAC40CA32F24B5E.gr7.eu-west-1.eks.amazonaws.com
```
## Interact with the cluster with `kubectl`

## Continuous Integration and Continous Deployment (CI/CD)

### Github Actions (CI)

### ArgoCD (CD)

## Access application logs

## Security constraints
