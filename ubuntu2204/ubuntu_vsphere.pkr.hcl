packer {
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = "~> 1"
    }
  }
}

variable "vcenter_server" {
  type    = string
  default = ""
}

variable "vsphere_user" {
  type    = string
  default = ""
}

variable "vsphere_password" {
  type    = string
  default = ""
}

variable "datacenter" {
  type    = string
  default = ""
}

variable "cluster" {
  type    = string
  default = ""
}

variable "datastore" {
  type    = string
  default = ""
}

variable "folder" {
  type    = string
  default = ""
}

variable "network" {
  type    = string
  default = ""
}

source "vsphere-iso" "ubuntu" {
  vcenter_server      = var.vcenter_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = true
  vm_name             = "pkr-ubuntu-22.04-template"
  datacenter          = var.datacenter
  cluster             = var.cluster
  datastore           = var.datastore
  folder              = var.folder
  guest_os_type       = "ubuntu64Guest"
  CPUs                = 2
  RAM                 = 4096
  RAM_reserve_all     = true

  storage {
    disk_size = 20480
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  iso_paths = ["[sfo-w01-sfo-w01-vc01-sfo-w01-cl01-vsan01] 483c3262-4288-1c8a-497f-78ac4463145c/ubuntu-22.04-live-server-amd64.iso"]
  
  boot_command: [
    <wait><wait><wait><wait><wait>
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
    "<enter><f10><wait>"
  ]
  
  http_directory = "http"
  shutdown_command = "echo 'shutdown -P now' > shutdown.sh; echo 'ubuntu'|sudo -S sh 'shutdown.sh'"
  ssh_username = "vmware"
  ssh_password = "VMware1!"
  ssh_wait_timeout = "20m"
}

build {
  sources = ["source.vsphere-iso.ubuntu"]

  provisioner "shell" {
    script = "setup.sh"
  }
}

