# GOV.UK Kubernetes Cluster User Documentation

## Introduction

The GOV.UK Kubernetes Platform is an AWS-hosted [Kubernetes](https://kubernetes.io) (aka **"k8s"**) cluster, using Amazon's [Elastic Kubernetes Service](https://aws.amazon.com/eks/) (aka **"EKS"**).

## Who is this documentation for?

## Kubernetes overview

Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both [declarative](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/) configuration and automation. Kubernetes manages the entire lifecycle of containerised applications (e.g. start, stop, update, scale), as well as providing mechanisms for:

- Service discovery and load balancing
- Persistent storage orchestration
- Automated rollouts and rollbacks
- Self-healing deployments
- Secrets and config management

See [What is Kubernetes?](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) for more details.

### Kubernetes declarative state model

Declarative configuration is a fundamental part of the design of Kubernetes, and it is important to understand the distinction between this declarative model and more traditional imperative models.

Briefly, the desired state of an application is submitted to the Kubernetes API (e.g. this container at a specific tag should be running, with these environment variables, with this port exposed to the internet), and Kubernetes internal components will then work to bring the current state of the application in line with the declared desired state; this is known as **state reconciliation**, and is handled via [Kubernetes controllers](https://kubernetes.io/docs/concepts/architecture/controller/).

### Kubernetes objects

The Kubernetes API supports many [object types](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) representing the state of component parts of an application. The major resource types that will be used in most (if not all) applications are:

* [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) - a group of one ore more containers
* [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) - one or more replicas of a pod, and an associated [deployment strategy](https://www.weave.works/blog/kubernetes-deployment-strategies)
* [Services](https://kubernetes.io/docs/concepts/services-networking/service/) - a means of exposing pods or deployments as a network service via a DNS name
* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) - a means of exposing Services externally via a load balancer, with associated SSL/TLS certificates and DNS names
* [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) - a collection of configuration key/value pairs, commonly used to provide environment variables to containers
* [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) - much like ConfigMap, but for smaller, sensitive key/value pairs

### Custom kubernetes objects

The GOV.UK Kubernetes Platform includes some third party API objects and controllers to allow for easy integration with AWS services:

* [ExternalSecrets](https://external-secrets.io) - stores secrets in [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/), and makes them available to applications as standard Kubernetes `Secret` objects
* [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/) - provides and manages AWS Load Balancers to fulfil `Ingress` objects' specifications
* [external-dns](https://github.com/kubernetes-sigs/external-dns) - creates and manages DNS records in AWS Route53 to fulfil `Ingress` objects' specifications


### Further Kubernetes Information

<!--
Content based on https://github.com/ministryofjustice/cloud-platform-user-guide/blob/main/source/documentation/concepts/kubernetes.html.md.erb
-->

Here are some links to introductory Kubernetes resources:

 * For a brief and light-hearted introduction to what Kubernetes is all about, try this [comic][k8s-comic] from Google.
 * [Concept video][k8s-video]
 * [Katacoda kubernetes course][] - In-browser, free (registration required), bite-sized kubernetes lessons.
 * [Pluralsight k8s course][]
 * [Udacity k8s course][]

[k8s-comic]: https://cloud.google.com/kubernetes-engine/kubernetes-comic/
[k8s-video]: https://www.youtube.com/watch?v=IMOZCDhH7do
[Pluralsight k8s course]: https://www.pluralsight.com/courses/kubernetes-getting-started
[Udacity k8s course]: https://eu.udacity.com/course/scalable-microservices-with-kubernetes--ud615
[Katacoda kubernetes course]: https://www.katacoda.com/courses/kubernetes


## Helm overview

## Tools setup

## Getting access to the cluster

## Interact with the cluster with `kubectl`

## Continuous Integration and Continous Deployment (CI/CD)

### Github Actions (CI)

### ArgoCD (CD)

## Access application logs

## Security constraints
