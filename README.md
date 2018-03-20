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

# Wildcard Certificates
Waiting on pull request https://github.com/jetstack/cert-manager/pull/309 which adds wildcard support to cert-manager.

# LetsEncrypt Certificate Management with cert-manager Edit

> k8 by example -- straight to the point, simple execution.

Certificate management as easy as a spec. Goes well with https://github.com/mateothegreat/k8-byexamples-ingress-controller.

## Usage

Run `make install` and you're ready to start creating certificate requests.
See the templates directory for certificate examples.

```sh
$ make help

                                __                 __
   __  ______  ____ ___  ____ _/ /____  ____  ____/ /
  / / / / __ \/ __  __ \/ __  / __/ _ \/ __ \/ __  /
 / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
 \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
/____
                        yomateo.io, it ain't easy.

Usage: make <target(s)>

Targets:

  certificate-issue    Creates a new Certificate request (make certificate-issue NS=somenamespace HOST=foo.bar.com)
  certificate-delete   Deletes Certificate request (make certificate-issue NS=somenamespace HOST=foo.bar.com)
  dump/submodules      Output list of submodules & repositories
  install              Installs manifests to kubernetes using kubectl apply (make manifests to see what will be installed)
  delete               Deletes manifests to kubernetes using kubectl delete (make manifests to see what will be installed)
  get                  Retrieves manifests to kubernetes using kubectl get (make manifests to see what will be installed)
  get/all              Retrives all resources (in color!)
  describe             Describes manifests to kubernetes using kubectl describe (make manifests to see what will be installed)
  context              Globally set the current-context (default namespace)
  shell                Grab a shell in a running container
  dump/logs            Find first pod and follow log output
  dump/manifests       Output manifests detected (used with make install, delete, get, describe, etc)


Tools:

  get/myip              Get your external ip
  testing-curl          Try to curl http & https from $(HOST)
  testing/curlhttp      Try to curl http://$(HOST)
  testing/curlhttps     Try to curl https://$(HOST)
  testing/getip         Retrieve external IP from api.ipify.org
  git/update            Update submodule(s) to HEAD from origin
  git/up                Update all .make submodules
  rbac/grant-google     Create clusterrolebinding for cluster-admin
```

## Creating new Certificates

Create a Certificate resource (see templates directory) via `make cert NS=somenamespace HOST=foo.bar.com`.
You can use `make logs` to follow the log output from the cert-manager pod and follow the action.

Example:

````sh
$ make certificate-issue NS=testing HOST=staticip.gcp.streaming-platform.com

certificate "staticip.gcp.streaming-platform.com" created

...
I0206 12:17:28.294092       1 controller.go:187] certificates controller: syncing item 'testing/staticip.gcp.streaming-platform.com'
I0206 12:17:28.294270       1 sync.go:107] Error checking existing TLS certificate: secret "tls-staticip.gcp.streaming-platform.com" not found
I0206 12:17:28.294342       1 sync.go:238] Preparing certificate with issuer
I0206 12:17:28.294844       1 prepare.go:239] Compare "" with "https://acme-v01.api.letsencrypt.org/acme/reg/28937938"
...
