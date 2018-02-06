<!--
#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
#-->

[![Clickity click](https://img.shields.io/badge/k8s%20by%20example%20yo-limit%20time-ff69b4.svg?style=flat-square)](https://k8.matthewdavis.io)
[![Twitter Follow](https://img.shields.io/twitter/follow/yomateod.svg?label=Follow&style=flat-square)](https://twitter.com/yomateod) [![Skype Contact](https://img.shields.io/badge/skype%20id-appsoa-blue.svg?style=flat-square)](skype:appsoa?chat)

# Fluentd Log Collection & Transport (via DaemonSet)

> k8 by example -- straight to the point, simple execution.

## Usage

Run `make install` and you're ready to start creating certificate requests.
See the templates directory for certificate examples.

```sh
$ make help

Usage:

  make <target>

Targets:

  install              Install resources to deploy cert-manager
  delete               Delete all resources needed for cert-manager

  status               Get rollout status (Watch until complete)
  dump                 Output all specs from the manifests directory (yaml)
  logs                 Find first pod and follow log output

  cert                 Generate Certificate request (make cert NS=somenamespace HOST=foo.bar.com)
```

## Creating new Certificates

Create a Certificate resource (see templates directory) via `make cert NS=somenamespace HOST=foo.bar.com`.
You can use `make logs` to follow the log output from the cert-manager pod and follow the action.

Example:

````sh
$ make cert NS=testing HOST=staticip.gcp.streaming-platform.com

certificate "staticip.gcp.streaming-platform.com" create

$ make logs

...
I0206 12:17:28.294092       1 controller.go:187] certificates controller: syncing item 'testing/staticip.gcp.streaming-platform.com'
I0206 12:17:28.294270       1 sync.go:107] Error checking existing TLS certificate: secret "tls-staticip.gcp.streaming-platform.com" not found
I0206 12:17:28.294342       1 sync.go:238] Preparing certificate with issuer
I0206 12:17:28.294844       1 prepare.go:239] Compare "" with "https://acme-v01.api.letsencrypt.org/acme/reg/28937938"
...

```
## Dump

```sh
$ make dump
envsubst < manifests/certificate-crd.yaml
##---
# Source: cert-manager/templates/certificate-crd.yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: certificates.certmanager.k8s.io
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
spec:
  group: certmanager.k8s.io
  version: v1alpha1
  names:
    kind: Certificate
    plural: certificates
  scope: Namespaced
envsubst < manifests/clusterissuer-crd.yaml
##---
# Source: cert-manager/templates/clusterissuer-crd.yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: clusterissuers.certmanager.k8s.io
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
spec:
  group: certmanager.k8s.io
  version: v1alpha1
  names:
    kind: ClusterIssuer
    plural: clusterissuers
  scope: Cluster
envsubst < manifests/issuer-crd.yaml
##---
# Source: cert-manager/templates/issuer-crd.yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: issuers.certmanager.k8s.io
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
spec:
  group: certmanager.k8s.io
  version: v1alpha1
  names:
    kind: Issuer
    plural: issuers
  scope: Namespaced
envsubst < manifests/rbac.yaml
##---
# Source: cert-manager/templates/rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: cert-manager
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
rules:
  - apiGroups: ["certmanager.k8s.io"]
    resources: ["certificates", "issuers", "clusterissuers"]
    verbs: ["*"]
  - apiGroups: [""]
    resources: ["secrets", "events", "endpoints", "services", "pods"]
    verbs: ["*"]
  - apiGroups: ["extensions"]
    resources: ["ingresses"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: cert-manager
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cert-manager
subjects:
  - name: cert-manager
    namespace: testing
    kind: ServiceAccount
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cert-manager
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
envsubst < manifests/deployment.yaml
##---
# Source: cert-manager/templates/deployment.yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: cert-manager
  labels:
    app: cert-manager
    chart: cert-manager-0.2.1
    release: cert-manager
    heritage: Tiller
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: cert-manager
        release: cert-manager
    spec:
      serviceAccountName: cert-manager
      containers:
        - name: cert-manager
          image: "quay.io/jetstack/cert-manager-controller:v0.2.3"
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              cpu: 10m
              memory: 32Mi

        - name: ingress-shim
          image: "quay.io/jetstack/cert-manager-ingress-shim:v0.2.3"
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              cpu: 10m
              memory: 32Mi
````
