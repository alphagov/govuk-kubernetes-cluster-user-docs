# GOV.UK Kubernetes Cluster User Documentation

## Introduction

The GOV.UK Kubernetes Platform is an AWS-hosted [Kubernetes](https://kubernetes.io) cluster, using Amazon's [Elastic Kubernetes Service](https://aws.amazon.com/eks/).

## Who is this documentation for?

As the GOV.UK Kubernetes Platform is currently in an early alpha stage, this documentation is intended for developers participating in user testing only.

## Kubernetes overview

Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services that:

- facilitates both [declarative configuration](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/) and automation
- manages the entire lifecycle of containerised applications (for example, start, stop, update, scale)

Kubernetes also enables:

- service discovery and load balancing
- persistent storage orchestration
- automated rollouts and rollbacks
- self-healing deployments
- secrets and configuration management

See the official [Kubernetes overview documentation](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) for more information.

### Kubernetes declarative state model

A core design concept of Kubernetes is the declarative state model, where Kubernetes users define their applications in terms of the desired end state. This differs from an imperative model, where users define the sequential steps to achieve a running application.

For example, with a declarative state model, a Kubernetes user defines that:

- a container `hello-world` with tag `v1` should be running
- that `hello-world` container should expose port 80
- a load balancer routing to port 80 on the container should exist

For an imperative model, a user would instead define the following steps.

1. Pull the `hello-world` container with tag `v1`.
2. Start the `hello-world` container with port 80 exposed.
3. Create a load balancer.
4. Create a load balancer routing rule pointing to port 80 on the container.

In the Kubernetes declarative model, internal Kubernetes components called [controllers](https://kubernetes.io/docs/concepts/architecture/controller/) handle the details of transitioning an application from the current state to the declared desired state on your behalf. See the [Imperative vs Declarative blog post](https://dominik-tornow.medium.com/imperative-vs-declarative-8abc7dcae82e) for a more detailed comparison of the two models.

### Kubernetes objects

The Kubernetes API supports many [object types](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) representing the state of component parts of an application. The following major resource types are used in most (if not all) applications:

* [`Pod`](https://kubernetes.io/docs/concepts/workloads/pods/) - a group of one or more containers
* [`Deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) - one or more replicas of a `Pod`, and an associated [deployment strategy](https://www.weave.works/blog/kubernetes-deployment-strategies)
* [`Service`](https://kubernetes.io/docs/concepts/services-networking/service/) - a means of exposing `Pod` or `Deployment` objects as a network service using a [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) name
* [`Ingress`](https://kubernetes.io/docs/concepts/services-networking/ingress/) - a means of exposing `Service` objects externally via a load balancer, with associated [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificates and [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) names
* [`ConfigMap`](https://kubernetes.io/docs/concepts/configuration/configmap/) - a collection of configuration key/value pairs, commonly used to provide environment variables to Pod containers
* [`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/) - a collection of sensitive key/value pairs, commonly used to provide environment variables to containers

### Custom Kubernetes objects

The GOV.UK Kubernetes Platform includes the following third party API objects and controllers to allow AWS services to be used through the Kubernetes API:

* [external-secrets](https://external-secrets.io) - stores secrets in [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/), and makes them available to applications as standard Kubernetes `Secret` objects
* [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/) - provides and manages AWS Load Balancers to fulfil `Ingress` objects' specifications
* [external-dns](https://github.com/kubernetes-sigs/external-dns) - creates and manages [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) records in [AWS Route 53](https://aws.amazon.com/route53/) to fulfil `Ingress` objects' specifications


### Further Kubernetes information

<!--
Content based on https://github.com/ministryofjustice/cloud-platform-user-guide/blob/main/source/documentation/concepts/kubernetes.html.md.erb
-->

Here are some links to introductory Kubernetes resources:

 * For a brief introduction to what Kubernetes is all about, try this [comic][k8s-comic] from Google.
 * [Kubernetes concepts video][k8s-video]
 * [Katacoda kubernetes course][] - In-browser, free (registration required), bite-sized Kubernetes lessons.
 * [Pluralsight k8s course][]
 * [Udacity k8s course][]

[k8s-comic]: https://cloud.google.com/kubernetes-engine/kubernetes-comic/
[k8s-video]: https://www.youtube.com/watch?v=IMOZCDhH7do
[Pluralsight k8s course]: https://www.pluralsight.com/courses/kubernetes-getting-started
[Udacity k8s course]: https://eu.udacity.com/course/scalable-microservices-with-kubernetes--ud615
[Katacoda kubernetes course]: https://www.katacoda.com/courses/kubernetes


## Helm overview

## Set up tools

### Install Kubectl

You can use Homebrew to install Kubectl on macOS:

```sh
brew install kubectl
```

Test that Kubectl is working by running:

```sh
kubectl version --client
```

___What would success look like?___

___Q: Docker Desktop installs an old version of kubectl which causes Homebrew not to symlink its version into place. R: Go ahead and follow Homebrew's instruction (brew link --overwrite kubectl). Docker will work fine with the more up-to-date kubectl, and govuk-docker definitely won't be affected because it doesn't use Docker's k8s features.___



[Official installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)

### Install HELM

You can use Homebrew to install HELM on macOS:

```sh
brew install helm
```

Test Helm is working:

```sh
helm version
```

___What would success look like?___

[Official installation guide](https://helm.sh/docs/intro/install/)

### Install `gds-cli`

Install gds-cli:

```sh
brew install alphagov/gds/gds-cli
```

Test gds-cli:

```sh
gds --version
```

___What would success look like?___

### Install `aws-vault`

Install aws-vault:

```sh
brew install --cask aws-vault
```

Test aws-vault:

```sh
aws-vault --version
```

___What would success look like?___

Please refer to the documentation for [gds-cli](https://github.com/alphagov/gds-cli) and [aws-vault](https://github.com/99designs/aws-vault#readme) for more information.

## Getting access to the cluster

### Prerequisites

To access the Kubernetes cluster you must have:

- [access to AWS](https://docs.publishing.service.gov.uk/manual/get-started.html#7-get-aws-access)
- [installed](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools) and [set up gds-cli](https://docs.publishing.service.gov.uk/manual/get-started.html#8-access-aws-for-the-first-time)

### Assuming roles and testing access

1. Assume the proper IAM role using [gds-cli](https://github.com/alphagov/gds-cli#usage) by
exporting the AWS credentials for the appropriate GOV.UK environment and role:

    ```sh
    eval $(gds aws govuk-<govuk-environment>-<role> -e --art 8h)
    export AWS_REGION=eu-west-1
    ```

     where:
     - `<govuk-environment>` is the the GOV.UK environment that you want to get credentials (for example, `test` or `integration`)
     - `<role>` is the role mentioned in this [deploying terraform documentation](https://docs.publishing.service.gov.uk/manual/deploying-terraform.html#1-check-that-you-have-sufficient-access)
     - the `art` option is used to request that the AWS credentials last for the requested time.

    For the user research session , you should use the `eval $(gds aws govuk-integration-admin -e --art 8h)` command since the session is run in the Integration GOV.UK cluster and `admin` role will allow full access.

2. If this is your first time accessing the cluster through Kubectl:

    ```sh
    aws eks update-kubeconfig --name govuk
    ```

    This will add the `govuk` cluster to your Kubectl configuration in `~/.kube/config`.

    If this is not your first time accessing the cluster through Kubectl, then

3. Check that you have access:

    ```sh
    kubectl cluster-info
    ```

    If you have access, running this command should return information about the GOV.UK EKS cluster control plane. This information should look like this:

    ```sh
    Kubernetes control plane is https://{GOVUK_CLUSTER_ADDRESS}.{AWS_REGION}.eks.amazonaws.com
    ```
    ___If you do not have access...___

## Interact with the cluster with `kubectl`

This acts as a quick reference to Kubectl, listing some of the most common operations.

The examples here only address the most basic approach to these operations. For more options, please refer to the command-line help of `kubectl` subcommands, which you can access like this:

```sh
kubectl get --help
```

There is also a more detailed [cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) in the official Kubernetes documentation.

### Inspecting running instances of an application

To list running Pods:

```sh
kubectl -n <namespace> get pods
```

To view details for a Pod:

```sh
kubectl -n <namespace> describe pod <pod>
```

### Viewing logs

To access the logs of a running container:

```sh
kubectl -n <namespace> logs <pod>
```

### Viewing Kubernetes events

To see Kubernetes events, which can help debugging:

```sh
kubectl -n <namespace> get events
```

### Container shell

You can get a shell inside a running container:

```sh
kubectl -n <namespace> exec -it <pod> sh
```

For more information, click [here](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/)

### Pod port-forwarding

To forward port 5000 on localhost to port 5001 in the Pod:

```sh
kubectl -n <namespace> port-forward <pod> 5000:5001
```

## Continuous Integration (CI) and Continuous Deployment (CD)

### Github actions (CI)

With GitHub Actions, we can now automatically build and publish our docker image to our private GOV.UK production AWS Elastic Container Repository.

The GitHub Actions workflow CI yaml file can be found within each repository in the following location: `.github/workflows/ci.yaml`

When a user merges a branch to main, the GitHub Action Workflows will be triggered, the defined job within the ci.yaml file will then start.

Within the job there are steps which will checkout the code, build a new Docker image and then push that new Docker image to GOV.UK production AWS Elastic Container Repository.

Each new image will be tagged with merge commit GitHub simple hashing algorithm (SHA).

You can view the status of GitHub Actions CI on `https://github.com/alphagov/<application repo>/actions`. The workflow is named `Build and publish to ECR`.

#### Sensitive data

AWS credentials are stored as Github Organisation level secrets and have been made available to individual repos. If a new repo requires access to secrets, please [contact the Replatforming team on Slack](https://gds.slack.com/archives/C013F737737).

See the [documentation on GitHub Actions](https://docs.github.com/en/actions) for more information.

### ArgoCD (CD)

The GOV.UK Kubernetes Platform provides an [ArgoCD] instance for continuous
delivery of applications to the cluster.

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes. ArgoCD will replace the feature set currently provided by Deploy Jenkins.

#### Access the ArgoCD integration instance

NOTE: In future we will use our Google Accounts for Single Sign-On (SSO) to Argo.

Our MVP for user testing uses a shared username and password.

1. Authenticate to the Kubernetes cluster (see [getting access to the cluster])
2. Acquire the password for Argo:

    ```sh
    kubectl -n cluster-services get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    ```

3. Navigate to [ArgoCD (Integration)][argo-integration] and sign in using the
  username `admin` and the password acquired from the previous step.

[ArgoCD]: https://argo-cd.readthedocs.io/en/stable/
[getting access to the cluster]: #getting-access-to-the-cluster
[argo-integration]: https://argo.eks.integration.govuk.digital/

## Access application logs

You can view application logs using [`kubectl logs`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs).

### View logs for an app

```sh
kubectl logs -n apps deploy/<deployment> <container>
```

where:

  - `<deployment>` is the name of the Deployment for the app.
  - `<app>` is the name of the container you want to view logs from.

For example:

```sh
kubectl logs -n apps deploy/publisher-web app
```

### View logs for a specific pod

```sh
kubectl logs -n apps <pod> <container>
```

where:

  - `<pod>` is the name of the Pod you want to view logs from.
  - `<container>` is the name of the container you want to view logs from.

For example:

```
kubectl logs -n apps frontend-7bd8c786d-t5x99 frontend
```

We recommend using [tab completion](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete) to avoid the need to copy-paste pod and container names.

See the [`kubectl` Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#interacting-with-running-pods) for more examples.

## Security constraints

## AWS integrations

The Kubernetes cluster interacts with AWS services to provide features
such as DNS, ALB ingress, and Secret provisioning.
Here we list the operators installed in the cluster that integrate with AWS.

* Secrets: The cluster uses the [external-secrets] operator to access secrets
in AWS Secrets Manager and automatically injects the values as Kubernetes Secrets.
* DNS: [external-dns] is a Kubernetes addon that configures public DNS servers
(in our case AWS Route53) with information about exposed Kubernetes services
to make them discoverable.
* ALB Ingress: [aws-load-balancer-controller] provisions AWS ALBs for Kubernetes
Ingress resources and NLBs for Kubernetes Services.
* Cluster autoscaling: [cluster-autoscaler] is responsible for managing
AWS EC2 Auto Scaling Groups to ensure pods won't fail due to insufficient
resources and nodes aren't underutilized.

[external-secrets]: https://github.com/external-secrets/external-secrets
[external-dns]: https://github.com/kubernetes-sigs/external-dns
[aws-load-balancer-controller]: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/
[cluster-autoscaler]: https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler
