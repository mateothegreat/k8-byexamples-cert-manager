#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#

NS              ?= testing
APP             ?= cert-manager
export

## Install all resources
install:    install-certificate-crd install-clusterissuer-crd install-issuer-crd install-rbac install-deployment
## Delete all resources
delete:     delete-certificate-crd delete-clusterissuer-crd delete-issuer-crd delete-rbac delete-deployment
## Get rollout status (Watch until complete)
status:     status-deployment

# LIB
install-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) apply -f -

delete-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) delete --ignore-not-found -f -

status-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) rollout status -w -f -

dump-%:
	envsubst < manifests/$*.yaml
## Find first pod and follow log output
logs:
	kubectl --namespace $(NS) logs -f $(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}') -c cert-manager

# Help Outputs
GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
RESET  		:= $(shell tput -Txterm sgr0)
help:

	@echo "\nUsage:\n\n  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}\n\nTargets:\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-20s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo
# EOLIB
