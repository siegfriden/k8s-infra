-include .env
export

.PHONY: provision reinstall update-config master-key users forget tunnel kubeconfig bootstrap

provision:
	ansible-playbook -i "$(SERVER_HOST)," -u root ansible/provision.yaml
reinstall:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/reinstall.yaml
update-k3s:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/update-k3s.yaml
update-gateway-api:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/update-gateway-api.yaml
master-key:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/master-key.yaml
users:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/users.yaml

tf-init:
	terraform -chdir=terraform init
tf-init-upgrade:
	terraform -chdir=terraform init -upgrade
tf-apply:
	terraform -chdir=terraform apply -auto-approve

forget:
	ssh-keygen -R $(SERVER_HOST)

tunnel:
	ssh -L 6443:localhost:6443 $(SERVER_USER)@$(SERVER_HOST)

kubeconfig:
	scp $(SERVER_USER)@$(SERVER_HOST):/etc/rancher/k3s/k3s.yaml ./kubeconfig

bootstrap: kubeconfig
	GITHUB_TOKEN=$(GITHUB_PAT) flux bootstrap github \
		--kubeconfig=./kubeconfig \
		--owner=nathansiegfrid \
		--repository=k8s-infra \
		--branch=main \
		--path=kubernetes \
		--personal

seal-secret:
	kubeseal --format yaml < secret.yaml > sealed-secret.yaml

forward-kyverno:
	kubectl port-forward service/policy-reporter-ui 8082:8080 -n kyverno
forward-linkerd:
	kubectl port-forward service/web 8084:8084 -n linkerd-viz
