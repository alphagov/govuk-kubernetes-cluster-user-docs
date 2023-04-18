---
title: Kubernetes command line
weight: 20
last_reviewed_on: 2023-04-18
review_in: 6 months
---

# Familiarise yourself with `kubectl`, the Kubernetes command-line tool

This tutorial will show you how to use the `kubectl` command line tool.
You need to have completed the [set up instructions](/get-started/set-up-tools/) and [tested your access](/get-started/access-eks-cluster/#test-your-access).

## Fetch logs from a pod

[Set your context](https://govuk-k8s-user-docs.publishing.service.gov.uk/get-started/access-eks-cluster/#select-a-role-and-environment) as below:

```sh
export AWS_REGION=eu-west-1
eval $(gds aws govuk-integration-readonly -e --art 8h)
```

Fetch the list of pods:

```sh
kubectl -n apps get pods
```

This will return a list, including output like:

```
NAME                                                              READY   STATUS             RESTARTS           AGE
account-api-568d46d6f7-4pnld                                      2/2     Running            0                  34m
account-api-568d46d6f7-txwsx                                      2/2     Running            0                  34m
account-api-dbmigrate-6n5mp                                       0/1     Completed          0                  35m
account-api-worker-54597b666c-jlcfn                               1/1     Running            0                  34m
asset-manager-7bd745d655-tzlgz                                    2/2     Running            0                  15h
...
```

As you can see above, each pod either runs the application (we can see two pods running Account API, for example) or runs a worker or cron job for the application (we can see one pod running the Account API application worker).

You can fetch the logs for all running containers in a pod. Take one of the pods from the output above:

```sh
kubectl -n apps logs account-api-568d46d6f7-4pnld
```

Or you can fetch the logs using its 'app deployment' name. This will choose one of the Account API pods at random, much like the old jumpbox methods:

```sh
kubectl -n apps logs deploy/account-api
```

We can make this command even shorter, by setting a default namespace so that we no longer need to specify `-n apps`:

```sh
kubectl config set-context --current --namespace=apps
kubectl logs deploy/account-api
```

Finally, we can alias `kubectl` to `k` as per the [Kubernetes cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).

```sh
alias k=kubectl # do this in your bash profile
k logs deploy/account-api
```

## Open a Rails console on a pod

If you now run:

```sh
k exec -it deploy/whitehall-admin -- rails c
```

...you'll see a permissions error:

```sh
Defaulted container "app" out of: app, nginx
Error from server (Forbidden): pods "whitehall-admin-6bb47c48d-wkkxk" is forbidden: User "christopher.ashton-user" cannot create resource "pods/exec" in API group "" in the namespace "apps"
```

This is because we set a readonly context earlier. We need write permissions to be able to open a console. Let's correct this now:

```sh
eval $(gds aws govuk-integration-poweruser -e --art 8h)
```

Now when you try the command to open a Rails console, it succeeds!

## Open a shell on a pod

With your 'write' permissions set, you should be able to open a shell:

```sh
k exec -it deploy/whitehall-admin -- bash
```

Note that the prompt will have prefix that may feel a little unfamiliar: `I have no name!@whitehall-admin-6bb47c48d-wkkxk:/app$`.

If you try to open a shell on Router, it will fail:

```sh
$ k exec -it deploy/router -- bash                                                               
Defaulted container "app" out of: app, nginx
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "e870a2214da6273408c75773234b09c245210d3f1dff3b200c096f24c7259f7f": OCI runtime exec failed: exec failed: unable to start container process: exec: "bash": executable file not found in $PATH: unknown
```

This is because [Router's image is `FROM scratch`](https://github.com/alphagov/router/blob/9797473edbbcbb5085fdca006bec7f6b1552f4e6/Dockerfile#L7), so bash isn't available. You'll need to exec into the nginx container instead (which does have a shell):

```sh
k exec -it deploy/router -c nginx -- bash
```

## Run a rake task on a pod

Here's an idempotent rake task you can run:

```sh
k exec deploy/email-alert-api -- rake 'support:view_emails[your.email@digital.cabinet-office.gov.uk]'
```

Note that we haven't specified the `-it` flags in the command above.
To find out what they do, run `k exec --help`.
