# vagrant-lab
Provision VMs for Development Labs.
---
## **Context**

This repository arose from the need for constant provisioning of virtual machines for studies and development tests.


## **Requirements**

- **Vagrant**

First of all, it is required the [vagrant binary package](https://developer.hashicorp.com/vagrant/downloads). For more instructions about Vagrant Installation, access this [link](https://developer.hashicorp.com/vagrant/tutorials/getting-started/getting-started-install?product_intent=vagrant).

  Check if vagrant is installed.

```bash
  vagrant version
```

```
# Output example:
  Installed Version: 2.3.4
  Latest Version: 2.3.4
```

- **Oracle Virtualbox**

If you don't have Oracle Virtualbox installed, access this [link](https://www.virtualbox.org/wiki/Downloads) to install Oracle Virtualbox on your operating system.

## **Setting up this Project**

#### **Considerations**

- Optionally for this project, we have chosen to use [Alma Linux 8](https://app.vagrantup.com/almalinux/boxes/8).
- The network is configured for use in bridge mode.
- For provisioning, the same user used on the host will be created, adding it with sudo permissions.
- In this project, a mount point is being created between the hypervisor and the VMS (`/share/nfs`). Make sure you have an existing mount point on your local machine.
- Configure shell provisioning according to your needs.

### **User custom settings**

Before spinning up this lab, download the Alma Linux 8 box:

```
vagrant box add almalinux/8 --force
```

Edit the `Vagrantfile`. It is necessary to fill in the variables section according to your local environment:

Example:

```yaml
  # Variables Environment
  username = ENV['USER']  
  interface = "eth0"
  range = "192.168.10."
  netmask = "255.255.255.0"
  gateway = "192.168.10.254"
  pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQkZa2XCHDdwjL84GfPkC/32j6cX+mlukc0DVXPyDGVwpGiOxK4kUCPkmM6aLHJF6gI3US4TN/37TQSWFtWTVoPFXqjMjhB0keD43p7RU7JSe4a1EuaVrw6IehsL7At25zdpQIk5cdFC/4x4OEEJAjbET4d+GxMHl+g0WxUKUgOAGQXZO9ZYN3b3eFUd84vcmV3TicYOofigjHpcF9vaG84WqYiPtC29mjlRQ1s0hEQJfdWPpMzgEQ9a76KOGXuKqYfQJj/JIav4u5PUNBBdKfMZSoNmmzhMAEbmxCBDumI9gM8z5pzHh+O8QPv/+N4QyNWXSUfLIFXI8onCzQLv1fSqQz3sodLYrM/rOgne0Ok2AykhUYNw+ee546eH5tHWAFQ8Kaeb498o3rGaE19KFCSyWEcXROUOyDSXWvnUzWWp++qhG2SSe+VZu6KCT8pJNcA4kaidrg9VN7Tc4HzDAi2IknMUB40Waua/TN5Gvns8xRSPid4eZeqh2augOfVkXVLKFtUNj31vcj4F7PrXZv9i52xbrt7Hz+bsc/ioGe+7r2clkYX2FqMdVVfp5G6nUF4zim1Ca/q+ITMQfgUKc9vgbfebMjnxZqh+ItyBW8dhzHtJNgp3V7HqfdwTwVl/KWD4KB6mB8CFaQHnC2m396bS8EVGSPRZn1amvxEXpsKw=="

  # Variables for VM Settings
  memory = "1024"
  cpu = "1"

  # Number of VMs Lab to create
  num_vms = 3
```

- **username**:  *It will capture your user in use and create it on the VMs.*
- **interface**: *Interface name of your host for bridge network configuration.*
- **range**: *Ips range based on your local network to create machines.*
- **netmask**: *Your network configuration.*
- **gateway**: *Default gateway of your local network.*
- **pubkey**: *Your public ssh key that will be added to authorized_keys.*
- **memory**: *VMs memory*
- **cpu**: *VMs CPU*
- **num_vms**:  *Number of VMs to be created.*

After configuring the `Vagrantfile`, go to the directory where it is located and run:

```bash
cd AlmaLinux8
vagrant up
```

That's it. You will have an environment according to your settings. Enjoy!

---
License
-------

GPL-3.0 License

Author Information
------------------

Alex Mendes

https://www.linkedin.com/in/mendesalex/
