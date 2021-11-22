# GOV.UK Kubernetes Cluster User Documentation

## Introduction

## Who is this documentation for?

## Kubernetes overview

## Helm overview

## Tools setup

## Getting access to the cluster

### Prerequesite
To follow this guide you will need to have an [AWS access](https://docs.publishing.service.gov.uk/manual/get-started.html#7-get-aws-access), have [gds-cli installed](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools) and have [gds-cli set up](https://docs.publishing.service.gov.uk/manual/get-started.html#8-access-aws-for-the-first-time) to access AWS.

### Follow those steps
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
Kubernetes control plane is https://{GOVUK_CLUSTER_ADDRESS}.{AWS_REGION}.eks.amazonaws.com
```
## Interact with the cluster with `kubectl`

## Continuous Integration and Continous Deployment (CI/CD)

### Github Actions (CI)

### ArgoCD (CD)

## Access application logs

## Security constraints
