# vagrant-lab
Provision VMs for Development Labs.
---
## **Context**

This repository arose from the need for constant provisioning of virtual machines for studies and development tests.


## **Requirements**

- **Vagrant**

First of all, it is required the [vagrant binary package](https://developer.hashicorp.com/vagrant/downloads). For more instructions about Vagrant Installation, access this [link](https://developer.hashicorp.com/vagrant/tutorials/getting-started/getting-started-install?product_intent=vagrant).

  Check if vagrant is installed.

```shell
  vagrant version
```

```shell
# Output example:
  Installed Version: 2.3.4
  Latest Version: 2.3.4
```

- **Oracle Virtualbox**

If you don't have Oracle Virtualbox installed, access this [link](https://www.virtualbox.org/wiki/Downloads) to install Virtualbox on your operating system.

---
## **Setting up this Project**

#### **Considerations**

- Optionally for this project, I have chosen to use [Alma Linux 8](https://app.vagrantup.com/almalinux/boxes/8).
- The network is configured for use in bridge mode.
- For provisioning, the same user used on the host will be created, adding it with sudo permissions.
- In this project, a mount point is being created between the Host and the VMS). *It is optional (fell free to comment this line if you don't want to use it)*.
- Configure shell provisioning according to your needs.
- In order to make this environment shareable, the implementation of variables using the [**vagrant-env**](https://github.com/gosuri/vagrant-env) **plugin** is being used:

```shell
cd AlmaLinux8
vagrant plugin install vagrant-env
```

This plugin enables loading variables from **`.env`** file where we are defining the following parameters:

- IFACE (**interface**): *Interface name of your host for bridge network configuration.*
- PUBKEY (**pubkey**): *Your public ssh key string that will be added to authorized_keys.*
- BASEIP (**base_ip**): *Your IP address base index. Change to desired IP index*.
- NETMASK (**netmask**): *Check your host network configurations for setting your netmask.*
- GATEWAY (**gateway**): *Default gateway of your local network.*
- PREFIX (**prefix**): Change it to desired hostname index.
- MEMORY (**memory**): *VMs memory*
- CPU (**cpu**): *VMs CPU*
- GROUP (**group**): *Grouping of VMs*

|***Note**: Inside of `Vagrantfile` it is also possible to customize the following extra arguments:
- **num_vms**:  *Number of VMs to be created.*
- **username**: *It will capture 'automatically' from your current host user and will be created it on the VMs.*
- **synced_folder**: *Change to your desired source/destination folders or comment if you don't want to use it (optional)*.

**`.env`** (example):

```shell
  # Variables Environment
  PUBKEY='ssh-rsa AAAAC3NzaC1lZDI1NTE5BBADE6VZXR7....'
  IFACE='eth0'
  BASEIP='192.168.0.10'
  NETMASK='255.255.255.0'
  GATEWAY='192.168.0.1'
  PREFIX='lab'
  MEMORY='1024'
  CPU='1'
  GROUP='MyLabs'
```

## **Let's running!**

Before spinning up this lab, download the Alma Linux 8 box:

```shell
vagrant box add almalinux/8 --force
```

**Example:**
```shell
vagrant box add almalinux/8 --force
==> box: Loading metadata for box 'almalinux/8'
    box: URL: https://vagrantcloud.com/almalinux/8
This box can work with multiple providers! The providers that it
can work with are listed below. Please review the list and choose
the provider you will be working with.

1) hyperv
2) libvirt
3) virtualbox
4) vmware_desktop

Enter your choice: 3
==> box: Adding box 'almalinux/8' (v8.7.20230228) for provider: virtualbox
    box: Downloading: https://vagrantcloud.com/almalinux/boxes/8/versions/8.7.20230228/providers/virtualbox.box
    box: Calculating and comparing box checksum...
==> box: Successfully added box 'almalinux/8' (v8.7.20230228) for 'virtualbox'!
```

After configuring the `Vagrantfile`, go to the directory where it is located and run:

```shell
cd AlmaLinux8
source .env
vagrant up
```

If you want to destroy your environment just run:

```shell
vagrant destroy
```

```shell
# Example:

vagrant destroy
    lab1: Are you sure you want to destroy the 'lab1' VM? [y/N] y
==> lab1: Forcing shutdown of VM...
==> lab1: Destroying VM and associated drives...
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
