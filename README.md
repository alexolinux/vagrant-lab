# vagrant-lab
Provision VMs for Development Labs.
---
## **Context**

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

- Optionally for this project, I have chosen to use [Alma Linux 8](https://app.vagrantup.com/almalinux/boxes/8).
- The network is configured for use in bridge mode.
- For provisioning, the same user used on the host will be created, adding it with sudo permissions.
- In this project, a mount point is being created between "Host & VMS". *It is optional (fell free to comment this line if you don't want to use it)*.
- Configure shell provisioning according to your needs.

## **Setting up this Project**

Follow the following steps:

1. Clone this project:
```shell
git clone https://github.com/alexmbarbosa/vagrant-lab.git
```

2.1. Go to `AlmaLinux8` folder and activate vagrant-env plugin:

```shell
cd AlmaLinux8
vagrant plugin install vagrant-env
```

2.2 After that, create the required `.env` file to load parameters that will be used by vagrant provisioning:

```shell
vim .env
```

```shell
# .env: 'Variables Environment'
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

```shell
# Save and exit:
:wq
```

vagrant-env enables loading variables from **`.env`** file where we are defining the following parameters:

- IFACE (**interface**): *Interface name of your host for bridge network configuration.*
- PUBKEY (**pubkey**): *Your public ssh key string that will be added to authorized_keys.*
- BASEIP (**base_ip**): *Your IP address base index. Change to desired IP index*.
- NETMASK (**netmask**): *Check your host network configurations for setting your netmask.*
- GATEWAY (**gateway**): *Default gateway of your local network.*
- PREFIX (**prefix**): Change it to desired hostname index.
- MEMORY (**memory**): *VMs memory*
- CPU (**cpu**): *VMs CPU*
- GROUP (**group**): *Grouping of VMs (If this group already exists in Virtualbox)*

> *You might copy/paste from `env_template` to `.env` editing your custom values.* 

In addition to the existing parameters in the `.env`, there are also the following parameters inside of `Vagrantfile`:
- **num_vms**:  *Number of VMs to be created.*
- **username**: *It will capture 'automatically' from your current host user and will be created it on the VMs.*
- **synced_folder**: *Change to your desired source/destination folders or comment if you don't want to use it (optional)*.
  * *If you want to use mountpoint with `sync_folder` make sure the directory exists on your host/workstation.*

> **Note: If you want to use `provisioner.sh` script, you need to specify your Hostname and IP Address of your workstation:
```shell
HOSTIP='<YourIpHere>'
HOSTALIAS='<YourHostnameHere>'
```

## **Let's running!**

### **Option 1: Using Makefile**

1. Check Environment:

```shell
make test
```

2. Up/Running:

```shell
make run
```

3. Destroy Environment

```shell
make destroy
```

### **Option 2: Running manually**

1. Before spinning up this lab, download the Alma Linux 8 box (make sure you are in `AlmaLinux8`):

```shell
cd AlmaLinux8
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

2. After configuring the `Vagrantfile`, run:

```shell
source .env
vagrant up
```

```shell
vagrant up

Bringing machine 'vm1' up with 'virtualbox' provider...
==> vm1: Importing base box 'almalinux/8'...
==> vm1: Matching MAC address for NAT networking...
==> vm1: Checking if box 'almalinux/8' version '8.7.20230228' is up to date...
==> vm1: Setting the name of the VM: AlmaLinux8_vm1_1683768483228_41318
==> vm1: Clearing any previously set network interfaces...
==> vm1: Preparing network interfaces based on configuration...
    vm1: Adapter 1: nat
    vm1: Adapter 2: bridged
==> vm1: Forwarding ports...
    vm1: 22 (guest) => 2222 (host) (adapter 1)
==> vm1: Running 'pre-boot' VM customizations...
==> vm1: Booting VM...
==> vm1: Waiting for machine to boot. This may take a few minutes...
    vm1: SSH address: 127.0.0.1:2222
    vm1: SSH username: vagrant
    vm1: SSH auth method: private key
    vm1: 
    vm1: Vagrant insecure key detected. Vagrant will automatically replace
    vm1: this with a newly generated keypair for better security.
    vm1: 
    vm1: Inserting generated public key within guest...
    vm1: Removing insecure key from the guest if it's present...
    vm1: Key inserted! Disconnecting and reconnecting using new SSH key...
==> vm1: Machine booted and ready!
==> vm1: Checking for guest additions in VM...
    vm1: The guest additions on this VM do not match the installed version of
    vm1: VirtualBox! In most cases this is fine, but in rare cases it can
    vm1: prevent things such as shared folders from working properly. If you see
    vm1: shared folder errors, please make sure the guest additions within the
    vm1: virtual machine match the version of VirtualBox you have installed on
    vm1: your host and reload your VM.
    vm1: 
    vm1: Guest Additions Version: 6.1.40
    vm1: VirtualBox Version: 7.0
==> vm1: Setting hostname...
==> vm1: Configuring and enabling network interfaces...
==> vm1: Mounting shared folders...
    vm1: /sharing => /home/linuxer/Public
    vm1: /vagrant => /home/linuxer/vagrant-lab/AlmaLinux8
==> vm1: Running provisioner: shell...
... ... .................................................. ... .
```

In case of you make changes, run:

```shell
vagrant provision
```

`vagrant provision` will apply this changes on your cluster vms.

3. If you want to destroy your environment just run:

```shell
vagrant destroy
```

```shell
    vm1: Are you sure you want to destroy the 'vm1' VM? [y/N] y
==> vm1: Forcing shutdown of VM...
==> vm1: Destroying VM and associated drives...
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
