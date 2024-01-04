# Rocky9 Packer Builder for Proxmox

Use this as is or as a starting point for a more fully customized image.

## Getting started

To use this you will need:

* This repo `git clone https://github.com/dustinrue/proxmox-packer.git`
* ISO files for the OS you want to build an image for uploaded to Proxmox:
  * [Rocky Linux](https://rockylinux.org/download)
* A working [Proxmox](https://www.proxmox.com/en/) system
* [Packer](https://packer.io). This project is tested with Packer version 1.9.2
* The builder machine must be accessible to Proxmox or you must host the ks.cfg or inst.ks files somewhere publicly accessible and modify the packer.pkr.hcl file for the version you wish to build.

**The OS ISO file will need to be uploaded to your Proxmox system.**

The simplest way to get the ISO file on your Proxmox system is to use the "Download from URL" option on the disk/share that you configured for ISO files.

## Building an Image

You will first want to determine if your host running Packer can be accessed by the Proxmox host. This is because Packer will briefly run an http server so that the installer can download the kickstart file. If Proxmox is on the same network as your builder host and there are no other firewall restrictions on your builder host this should work fine. If not, you will need to copy/host the ks.cfg files on a publicly accessible server.

Next, you will need to know the URL to your Proxmox system, the name of the node to build on as well as a username and password of a user with sufficient privileges to create VMs and templates. If you have customized your install or are using a storage pool other than the default you will need to specify that as well.

With all of the information at hand, edit the `variables.pkrvars.hcl` file and update the variables. For a full set of variables you can look at the `rocky9/packer.pkr.hcl` file for a list of variables.

In addition to using the packer.pkr.hcl file you can also set some variables using environment variables. For example, I set my Proxmox password using the following variable:

```
docker run ... -e PROXMOX_PASSWORD=<scrubbed> ...
```

### Using the Makefile

You can build the Rocky9 templates by running:

* make rocky9

### Building manually

If you do not want to use the Makefile then the following commands will work:

```
packer build -var-file variables.pkrvars.hcl rocky9/packer.pkr.hcl
```

Note that RL9 now requires at least an Intel Nehalem processor or equivalent. You can read more at  https://www.phoronix.com/scan.php?page=news_item&px=RHEL-9-x86-64-v2-Plans

There are a number of other variables you can set. You will notice these closely match the available options for the [Proxmox builder](https://packer.io/docs/builders/proxmox.html). The full list of variables you can customize is:

* `proxmox_username` - username to log into Proxmox as
* `proxmox_password` - password to log into Proxmox as
* `proxmox_url` - URL of your Proxmox system
* `proxmox_node` - name of the Proxmox node to build on
* `proxmox_storage_pool` - name of the storage pool the image should be built on
* `proxmox_storage_pool_type` - type of storage pool, `lvm-thin` (default), `lvm` , `zfspool` or `directory`
* `proxmox_storage_format` - storage format, `raw` (default), `cow`, `qcow`, `qed`, `qcow2`, `vmdk` or `cloop` 
* `centos_image` or `ubuntu_image` - The OS image.
* `template_name` - Name of the template. Defaults to `CentOS7-Template` or `CentOS8-Template` depending on version
* `template_description` - Template description. Defaults to `CentOS 7 Template` or `CentOS 8 Template` depending on image being built.

## After the image is built

Once the image is built you will want to adjust any remaining settings in the template including creating a cloud-init drive. A cloud-init drive _must_ be created for you to ssh into any new VMs you create. For details on how to do so visit [https://blog.dustinrue.com/proxmox-cloud-init/](https://blog.dustinrue.com/proxmox-cloud-init/).

## Packer Via Docker

Pull dockerimage containing with the proxmox HCL configurations.

```
docker pull andygodish/base-hashicorp-packer-1.9-proxmox
```

Run docker image with the following command making sure to pass in the PROXMOX_PASSWORD and `varialbes.pkrvars.hcl` file.

```
docker run -it --rm \
  --network="host" \
  -e PROXMOX_PASSWORD=<scrubbed> \
  -v ${PWD}/variables.pkrvars.hcl:/home/appuser/variables.pkrvars.hcl \
  andygodish/base-hashicorp-packer-1.9-proxmox:2023-10
```

## Issues

### DEBUG

PACKER_LOG=1 PACKER_LOG_TIMESTAMP=1 

> 2023/10/03 14:06:55 packer-plugin-proxmox_v1.1.5_x5.0_linux_amd64 plugin: 2023/10/03 14:06:55 [DEBUG] Error getting SSH address: 500 QEMU guest agent is not running

- [Github Issue](https://github.com/hashicorp/packer-plugin-proxmox/issues/91)

The issue is futher up the chain in that the VM in proxmox was unable to connect to the HTTP server deployed by Packer. This was due to the network traffic being unable to bridge to the IP address of the docker container. Setting the `--netowrk="host"` flag on the docker container resolved the issue.