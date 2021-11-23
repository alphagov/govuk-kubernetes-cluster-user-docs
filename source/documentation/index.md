# GOV.UK Kubernetes Cluster User Documentation

## Introduction

The GOV.UK Kubernetes Platform is an AWS-hosted [Kubernetes](https://kubernetes.io) cluster, using Amazon's [Elastic Kubernetes Service](https://aws.amazon.com/eks/).

## Who is this documentation for?

As the GOV.UK Kubernetes Platform is currently in an early alpha stage, this documentation is intended for developers participating in user testing only.

## Kubernetes overview

Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both [declarative configuration](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/) and automation. Kubernetes manages the entire lifecycle of containerised applications (for example, start, stop, update, scale), as well as providing mechanisms for:

- service discovery and load balancing
- persistent storage orchestration
- automated rollouts and rollbacks
- self-healing deployments
- secrets and config management

See the official [Kubernetes overview documentation](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) for more details.

### Kubernetes declarative state model

A core design concept of Kubernetes is the declarative state model, where Kubernetes users define their applications in terms of the desired end state. This differs from an imperative model, where the sequential steps to achieve a running application are defined instead. For example:

#### Declarative

* Container `hello-world` with tag `v1` should be running
* The `hello-world` container should expose port 80
* A load balancer routing to port 80 on the container should exist

#### Imperative

1. Pull the `hello-world` container with tag `v1`
2. Start the `hello-world` container with port 80 exposed
3. Create a load balancer
4. Create a load balancer routing rule pointing to port 80 on the container

In the Kubernetes declarative model, internal Kubernetes components called [controllers](https://kubernetes.io/docs/concepts/architecture/controller/) handle the details of transitioning an application from the current state to the declared desired state on your behalf. See [Imperative vs Declarative](https://dominik-tornow.medium.com/imperative-vs-declarative-8abc7dcae82e) for a more detailed comparison of the two models.


### Kubernetes objects

The Kubernetes API supports many [object types](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) representing the state of component parts of an application. The major resource types that will be used in most (if not all) applications are:

* [`Pod`](https://kubernetes.io/docs/concepts/workloads/pods/) - a group of one or more containers
* [`Deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) - one or more replicas of a `Pod`, and an associated [deployment strategy](https://www.weave.works/blog/kubernetes-deployment-strategies)
* [`Service`](https://kubernetes.io/docs/concepts/services-networking/service/) - a means of exposing `Pod` or `Deployment` objects as a network service using a [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) name
* [`Ingress`](https://kubernetes.io/docs/concepts/services-networking/ingress/) - a means of exposing `Service` objects externally via a load balancer, with associated [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificates and [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) names
* [`ConfigMap`](https://kubernetes.io/docs/concepts/configuration/configmap/) - a collection of configuration key/value pairs, commonly used to provide environment variables to Pod containers
* [`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/) - a collection of sensitive key/value pairs, commonly used to provide environment variables to containers

### Custom Kubernetes objects

The GOV.UK Kubernetes Platform includes some third party API objects and controllers to allow AWS services to be used through the Kubernetes API:

* [external-secrets](https://external-secrets.io) - stores secrets in [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/), and makes them available to applications as standard Kubernetes `Secret` objects
* [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/) - provides and manages AWS Load Balancers to fulfil `Ingress` objects' specifications
* [external-dns](https://github.com/kubernetes-sigs/external-dns) - creates and manages [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) records in [AWS Route 53](https://aws.amazon.com/route53/) to fulfil `Ingress` objects' specifications


### Further Kubernetes Information

<!--
Content based on https://github.com/ministryofjustice/cloud-platform-user-guide/blob/main/source/documentation/concepts/kubernetes.html.md.erb
-->

Here are some links to introductory Kubernetes resources:

 * For a brief introduction to what Kubernetes is all about, try this [comic][k8s-comic] from Google.
 * [Kubernetes concepts video][k8s-video]
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

This acts as a quick reference to kubectl, listing some of the most common operations.

The examples here only address the most basic approach to these operations. For more options, please refer to the command-line help of kubectl subcommands, which you can access like this:
```
$ kubectl get --help
```

There is also a more detailed [cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) in the official kubernetes documentation.

### Inspecting running instances of an application

To list running Pods:
```
$ kubectl -n <namespace> get pods
```

To view details for a Pod:
```
$ kubectl -n <namespace> describe pod <pod>
```

### Viewing logs

To access the logs of a running container:
```
$ kubectl -n <namespace> logs <pod>
```

### Viewing kubernetes events

To see kubernetes events, which can help debugging:
```
$ kubectl -n <namespace> get events
```

### Container shell

You can get a shell inside a running container:
```
$ kubectl -n <namespace> exec -it <pod> sh
```

For more information, click [here](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/)

### Pod port-forwarding

To forward port 5000 on localhost to port 5001 in the Pod:
```
$ kubectl -n <namespace> port-forward <pod> 5000:5001
```

## Continuous Integration and Continous Deployment (CI/CD)

### Github Actions (CI)

With GitHub Actions, we can now automatically build and publish our docker image to our private GOV.UK production AWS Elastic Container Repository.

The GitHub Actions workflow CI yaml file can be found within each repository in the following location: `.github/workflows/ci.yaml`

When a user merges a branch to main, the GitHub Action Workflows will be triggered, the defined job within the ci.yaml file will then start.
Within the job there are steps which will checkout the code, build a new Docker image and then push that new Dcoker image to GOV.UK production AWS Elastic Container Repository.
Each new image will be tagged with merge commit GitHub simple hashing algorithm (SHA).

You can view the status of GitHub Actions CI on `https://github.com/alphagov/<application repo>/actions`. The workflow is named `Build and publish to ECR`.

#### Sensitive data
AWS credentials are stored as Github Organisation level secrets and have been made available to individual repos. If a new repo requires access to secrets, please [contact the Replatforming team on Slack](https://gds.slack.com/archives/C013F737737).

[Official documentation on GitHub action](https://docs.github.com/en/actions)

### ArgoCD (CD)

The GOV.UK Kubernetes Platform provides an [ArgoCD] instance for continuous
delivery of applications to the cluster.

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes.
ArgoCD will replace the feature set currently provided by Deploy Jenkins.

#### Access the ArgoCD integration instance

NOTE: In future we will use our Google Accounts for Single Sign-On (SSO) to Argo.
Our MVP for user testing uses a shared username and password.

1. Authenticate to the Kubernetes cluster (see [getting access to the cluster])
2. Acquire the password for Argo:
  ```
  kubectl -n cluster-services get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
  ```
3. Navigate to [ArgoCD (Integration)][argo-integration] and sign in using the
  username `admin` and the password acquired from the previous step.

[ArgoCD]: https://argo-cd.readthedocs.io/en/stable/
[getting access to the cluster]: #getting-access-to-the-cluster
[argo-integration]: https://argo.eks.integration.govuk.digital/

## Access application logs

You can view application logs using [`kubectl logs`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs).

View logs for an app:

```
kubectl logs -n apps deploy/<deployment> <container>
```

- `<deployment>` is the name of the Deployment for the app.
- `<app>` is the name of the container you want to view logs from.

For example:

```
kubectl logs -n apps deploy/publisher-web app
```

View logs for a specific pod:

```
kubectl logs -n apps <pod> <container>
```

- `<pod>` is the name of the Pod you want to view logs from.
- `<container>` is the name of the container you want to view logs from.

For example:

```
kubectl logs -n apps frontend-7bd8c786d-t5x99 frontend
```

We recommend using [tab completion](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete) to avoid the need to copy-paste pod and container names.

See the [`kubectl` Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#interacting-with-running-pods) for more examples.

## Security constraints
