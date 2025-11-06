include .env

test:
	@echo "Running tests..."
	bash ./scripts/env_test.sh

start:	
	# Export .env variables for this recipe so Vagrant receives them even if
	# the vagrant-env plugin fails to load the .env file.
	set -a; \
	if [ -f .env ]; then . ./.env; fi; \
	set +a; \
	vagrant plugin install vagrant-env vagrant-vbguest && \
	vagrant box add $(DIST)/$(VER) --provider=virtualbox --force && \
	vagrant up --provider=virtualbox

update:
	vagrant reload --provision

destroy:
	vagrant destroy --force

.PHONY: test, start, update, destroy
