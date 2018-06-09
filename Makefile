#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
include .make/Makefile.inc

NS              ?= kube-system
APP             ?= cert-manager
HOST            ?= k8.yomateo.io
EMAIL           ?= matthew@matthewdavis.io

## Creates a new Certificate request (make certificate-issue NS=somenamespace HOST=foo.bar.com)
certificate-issue:  guard-HOST; @envsubst < templates/certificate.yaml | kubectl -n $$NS apply -f -
## Deletes Certificate request (make certificate-issue NS=somenamespace HOST=foo.bar.com)
certificate-delete:	guard-HOST; @envsubst < templates/certificate.yaml | kubectl -n $$NS delete --ignore-not-found -f -

logs:

	kubectl --namespace $(NS) logs -f $(shell kubectl get pods --namespace $(NS) -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}') -c cert-manager