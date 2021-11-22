# Continuous Integration
### Overview
This documentation will explains where Github Action CI workflow file can be found, and its purpose.

### GITHUB action CI
With GitHub Actions, we can now automatically build and publish our docker image to our private GOVUK production AWS ECR repository.

Github workflow CI has been added within application repo, named `ci.yaml`.
```sh
.github/workflows/ci.yaml
```
Github action CI is named `Build and publish to ECR`
```sh
https://github.com/alphagov/<application repo>/actions/workflows/ci.yaml
```

On each merge to main, the CI action will be triggered and a new Docker image will be built and published to GOVUK production AWS ECR, each image will be tagged with Github SHA.

Status of our CI job can be viewed
```sh
https://github.com/alphagov/<application repo>/actions
```
### Design
```sh
Merge to Master/Main -> build and publish docker image to AWS ECR
```
### Summary of Workflow
Without looking deeply into the code, in summary the workflow does the following;
```sh
on:
  push:
    branches:
      - main
    paths-ignore:
      - "Jenkinsfile"
      - ".git**"
```
The Above is the trigger for the Action. It states `on`, which triggers the workflow. Currently we have set trigger for `push` on branch `main`.
```sh
jobs:
  publish:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
      
      - name: Configure AWS credentials

      - name: Login to Amazon ECR

      - name: Build, tag, and push image to Amazon ECR
```
The above is what happens once trigger requirements have been met. 
One `job` is defined and it contains four `steps`. 
- First step, checkout the code.
- Second step, configures AWS credentials.
- Third step, logins to AWS ECR.
- Fourth step, builds the container, tags it with Github SHA and finally the container is pushed up to GOVUK AWS ECR repository.

### Sensitive data
AWS credentials have been stored as Github Organisation level secrets.

[Official doc on GitHub action](https://docs.github.com/en/actions)
