# vagrant-lab

## Provision Linux VMs by using Vagrant Boxes

---

## **Purpose**

This repository arose from the need for constant provisioning of virtual machines for studies and development tests.

## **Requirements**

1. **Vagrant**
2. **Vagrant Env plugin**
3. **Virtualbox**

### 1. **Vagrant**

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

### 2. **Vagrant Env** plugin

In order to make this environment shareable, the implementation of variables using the [**vagrant-env**](https://github.com/gosuri/vagrant-env) **plugin** shall to be used.

### 3. **Oracle Virtualbox**

If you don't have Oracle Virtualbox installed, access this [link](https://www.virtualbox.org/wiki/Downloads) to install Virtualbox on your operating system.

### **Considerations**

This project was created to ensure compatibility with various Linux flavors. Choose and specify your desired distro/version by accessing **[Vagrant Boxes](https://app.vagrantup.com/)**.

- The network is configured for use in bridge mode. The host interface will be requested during the provisioning steps. Specify it accordingly:

```shell
==> vm: Available bridged network interfaces:
1) eth0
2) wlan0

==> vm: When choosing an interface, it is usually the one that is
==> vm: being used to connect to the internet.
==> vm: Which interface should the network bridge to?
```

- For provisioning, the same user used on the host will be created, adding it with sudo permissions.
- In this project, a mount point is being created between "Host & VMS". *It is optional (fell free to comment this line if you don't want to use it)*.
- Configure shell provisioning according to your needs.

## **Setting up this Project**

Follow the following steps:

1 Clone this project:

```shell
git clone https://github.com/alexmbarbosa/vagrant-lab.git
```

2 **`vagrant-env`** loads variables from **`.env`** file defining the following parameters:

- DIST (**distro**): *Linux Distribution.*
- VER (**version**): *Linux Distro Release Version.*
- IFACE (**interface**): *Interface name of your host for bridge network configuration.*
- PUBKEY (**pubkey**): *Your public ssh key string that will be added to authorized_keys.*
- BASEIP (**base_ip**): *Your IP address "base index". Change to desired IP index*.
- NETMASK (**netmask**): *Check your host network configurations for setting your netmask.*
- GATEWAY (**gateway**): *Default gateway of your local network.*
- PREFIX (**prefix**): Change it to desired hostname index.
- MEMORY (**memory**): *VMs memory*
- CPU (**cpu**): *VMs CPU*
- GROUP (**group**): *Grouping of VMs (If this group already exists in Virtualbox)*

Create the required `.env` according to the `env_template`, add your personal configurations to be used by vagrant provisioning:

Go to `Linux` folder:

```shell
cd Linux
```

```shell
cp env_template .env
vim .env
```

```shell
# env_template

# MakeFile Variables
DIST        > Makefile Linux Distro.
VER         > Makefile Linux Distro Release Version.

# Variables Environment
IFACE       > Add your Host Interface Device
BASEIP      > Add your desired IP address index
NETMASK     > Add the netmask based on your local network configuration
GATEWAY     > Add the Default Gateway based on your local network configuration
PREFIX      > Replace for your desired VM name index.
MEMORY      > Replace for your desired memory ram.
CPU         > Replace for your desired memory CPU.
GROUP       > Replace for your desired VM group.
PUBKEY      > Add your SSH Pub key hash
```

```shell
# Example
DIST='centos'
VER='7'
PUBKEY='ssh-rsa AAAAC3NzaC1lZDI1NTE5BBADE6VZXR7....'
IFACE='eth0'
BASEIP='192.168.0.10'
NETMASK='255.255.255.0'
GATEWAY='192.168.0.1'
PREFIX='vm'
MEMORY='1024'
CPU='1'
GROUP='MyLabs'
```

```shell
# Save and exit:
:wq

# Activate your .env
source .env
```

In addition to the existing parameters in the `.env`, there are also the following customizable parameters inside of `Vagrantfile`:

- **num_vms**:  *Number of VMs to be created.*
- **username**: *It will capture 'automatically' from your current host user and will be created it on the VMs.*
- **synced_folder**: *Change to your desired source/destination folders or comment if you don't want to use it (optional)*.
  - *If you want to use mountpoint with `sync_folder` make sure the directory exists on your host/workstation.*

> **Note1:** *BASEIP variable works with the VM Count Index +1. It means if you configure `BASEIP='192.168.0.10'` the first VM will have the IP address `192.168.0.11'` assigned.*
> **Note2:** *If you want to use `provisioner.sh` script, you need to specify your Hostname and IP Address of your workstation:*

```shell
HOSTIP='<YourIpHere>'
HOSTALIAS='<YourHostnameHere>'
```

## **Let's running!**

### **Makefile**
A **Makefile** was implemented, becoming the startUP process simpler.

1) Check Environment:

```shell
make test
```

2) Provisioning VMs:

```shell
make run
```

3) Modifying VMs:

```shell
make update
```

4) Destroying VMs:

```shell
make destroy
```
That's it. You will have an environment according to your settings. Enjoy!

---

License
-------

GPL-3.0 License

Author Information
------------------

Alex Mendes

<https://www.linkedin.com/in/mendesalex/>
