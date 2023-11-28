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
  default = "your-vcenter-server"
}

variable "vsphere_user" {
  type    = string
}

variable "vsphere_password" {
  type    = string
  sensitive = true
}

variable "datastore" {
  type    = string
}

variable "datacenter" {
  type    = string
}

variable "folder" {
  type    = string
}

variable "cluster" {
  type    = string
}

variable "network" {
  type    = string
}

variable "winrm_username" {
  type    = string
}

variable "winrm_password" {
  type    = string
}

variable "windows_license_key" {
  type    = string
  description = "Windows License Key"
}

variable "admin_password" {
  type    = string
  description = "Administrator Password"
  sensitive = true
}


source "vsphere-iso" "windows11" {
  vcenter_server      = var.vcenter_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = true
  vm_name             = "HznWindows11Template"
  datacenter          = var.datacenter
  datastore           = var.datastore
  folder              = var.folder
  convert_to_template = true
  cluster             = var.cluster
  CPUs                = 2
  RAM                 = 4096

  guest_os_type       = "windows11_64Guest" // Adjust as needed
  iso_paths = ["[sfo-w01-sfo-w01-vc01-sfo-w01-cl01-vsan01] 483c3262-4288-1c8a-497f-78ac4463145c/en-us_windows_11_business_editions_version_22h2_updated_nov_2023_x64_dvd_19c44474.iso"]
  communicator        = "winrm"
  winrm_username      = var.winrm_username
  winrm_password      = var.winrm_password
  winrm_timeout       = "6h"
  shutdown_command    = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""

  storage {
    disk_size = 20480
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

}

build {
  sources = [
    "source.vsphere-iso.windows11"
  ]

  provisioner "windows-shell" {
    script = "/scripts/script.ps1"
  }
}

