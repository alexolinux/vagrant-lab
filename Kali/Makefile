test:
	@echo "Running tests..."
	bash ./scripts/env_test.sh

run:	
	vagrant plugin install vagrant-env vagrant-vbguest && \
	vagrant box add kalilinux/rolling --provider=virtualbox --force && \
	vagrant up --provider=virtualbox

destroy:
	vagrant destroy --force

.PHONY: test, run, destroy
