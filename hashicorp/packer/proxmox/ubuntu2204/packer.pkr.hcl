packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_iso_pool" {
  type    = string
  default = "pve-backups:iso"
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "proxmox_password" {
  type    = string
  default = ""
}

variable "proxmox_storage_format" {
  type    = string
  default = "qcow2"
}

variable "proxmox_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "proxmox_storage_pool_type" {
  type    = string
  default = "lvm-thin"
}

variable "proxmox_url" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = ""
}

variable "template_description" {
  type    = string
  default = "Ubuntu 22.04 Template"
}

variable "template_name" {
  type    = string
  default = "Ubuntu-22.04-Template"
}

variable "ubuntu_image" {
  type    = string
  default = "ubuntu-22.04.3-live-server-amd64.iso"
}

variable "version" {
  type    = string
  default = ""
}

source "proxmox-iso" "autogenerated_1" {
  boot_command = [
    "c", 
    "ip={{ user `vm_ip` }}::{{ user `vm_gateway` }}:{{ user `vm_netmask` }}::::{{ user `vm_dns` }} ",
    "linux /casper/vmlinuz -- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", 
    "<enter><wait><wait>", 
    "initrd /casper/initrd", 
    "<enter><wait><wait>", 
    "boot<enter>"
  ]

  # boot_command = [
  #       "<e><bs><down><down><down>",
  #       "<right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right>",
  #       "<spacebar>",
  #       "ip={{ user `vm_ip` }}::{{ user `vm_gateway` }}:{{ user `vm_netmask` }}::::{{ user `vm_dns` }} ",
  #       "autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
  #       "<F10>"
  # ]

  boot_wait    = "10s"
  cores        = "2" 
  cpu_type = "x86-64-v2-AES"
  qemu_agent = true
  disks {
    disk_size         = "8G"
    format            = "${var.proxmox_storage_format}"
    storage_pool      = "${var.proxmox_storage_pool}"
    type              = "scsi"
  }
  http_directory           = "ubuntu2204/http"
  insecure_skip_tls_verify = true
  iso_file                 = "${var.proxmox_iso_pool}/${var.ubuntu_image}"
  memory                   = "8192"
  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
    firewall = false
  }
  node                 = "${var.proxmox_node}"
  os                   = "l26"
  password             = "${var.proxmox_password}"
  token = "${var.proxmox_password}"
  proxmox_url          = "${var.proxmox_url}"
  scsi_controller      = "virtio-scsi-single"
  ssh_password         = "ubuntu"
  ssh_port             = 22
  ssh_timeout          = "30m"
  ssh_username         = "ubuntu"
  template_description = "${var.template_description}"
  template_name        = "${var.template_name}"
  unmount_iso          = true
  username             = "${var.proxmox_username}"

  # cloud_init = true
  # cloud_init_storage_pool = "local"
}

build {
  sources = ["source.proxmox-iso.autogenerated_1"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", 
      "sudo cloud-init clean", 
      "sudo passwd -d ubuntu"
    ]
  }

}
