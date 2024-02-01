include .env

test:
	@echo "Running tests..."
	bash ./scripts/env_test.sh

start:	
	vagrant plugin install vagrant-env vagrant-vbguest && \
	vagrant box add $(DIST)/$(VER) --provider=virtualbox --force && \
	vagrant up --provider=virtualbox

update:
	vagrant reload --provision

destroy:
	vagrant destroy --force

.PHONY: test, start, update, destroy
