-include .env
export

provision:
	ansible-playbook -i "$(SERVER_HOST)," -u root ansible/provision.yaml

master-key:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/master-key.yaml

users:
	ansible-playbook -i "$(SERVER_HOST)," -u $(SERVER_USER) ansible/users.yaml

forget:
	ssh-keygen -R $(SERVER_HOST)

kubeconfig:
	scp $(SERVER_USER)@$(SERVER_HOST):/etc/rancher/k3s/k3s.yaml ./kubeconfig
	sed -i '' 's/127.0.0.1/$(SERVER_HOST)/' kubeconfig
	@echo "export KUBECONFIG=$$(pwd)/kubeconfig"
