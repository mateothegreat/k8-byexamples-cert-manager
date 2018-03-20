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
export

certificate-issue:  guard-HOST; @envsubst < templates/certificate.yaml | kubectl -n $$NS apply -f -
certificate-delete:	guard-HOST; @envsubst < templates/certificate.yaml | kubectl -n $$NS delete --ignore-not-found -f -
