#!/bin/bash

# Salt Minion Bootstrap installation
# https://docs.saltproject.io/salt/install-guide/en/latest/topics/bootstrap.html#
# https://repo.saltproject.io/#directory-listing

HOSTALIAS='master'
VERSION='3006.1'

curl -Ss -# -L https://bootstrap.saltproject.io -o /tmp/bootstrap-salt.sh
sudo chmod +x /tmp/bootstrap-salt.sh
sudo bash /tmp/bootstrap-salt.sh -A ${HOSTALIAS} stable ${VERSION}

if [ $? -eq 0 ]; then
    echo "Salt is installed."
    if [ !  $(systemctl is-active salt-minion) = "active" ]; then 
        sudo systemctl start salt-minion
        echo "salt-minion was started!"
    fi
    salt-minion --version
else
    echo "Failure to install Salt."
    echo "Error code: ${$?}"
fi
