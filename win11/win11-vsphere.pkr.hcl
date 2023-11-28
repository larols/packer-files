variable "vsphere_server" {
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

variable "vsphere_datastore" {
  type    = string
}

variable "vsphere_datacenter" {
  type    = string
}

variable "vsphere_folder" {
  type    = string
}

variable "vsphere_cluster" {
  type    = string
}

variable "vsphere_network" {
  type    = string
}

variable "winrm_username" {
  type    = string
}

variable "winrm_password" {
  type    = string
}

source "vsphere-iso" "windows11" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = true
  vm_name             = "HznWindows11Template"
  datacenter          = var.vsphere_datacenter
  datastore           = var.vsphere_datastore
  folder              = var.vsphere_folder
  convert_to_template = true
  cluster             = var.vsphere_cluster
  network             = var.vsphere_network
  guest_os_type       = "windows11_64Guest" // Adjust as needed
  iso_paths = ["[sfo-w01-sfo-w01-vc01-sfo-w01-cl01-vsan01] 483c3262-4288-1c8a-497f-78ac4463145c/en-us_windows_11_business_editions_version_22h2_updated_nov_2023_x64_dvd_19c44474.iso"]
  communicator        = "winrm"
  winrm_username      = var.winrm_username
  winrm_password      = var.winrm_password
  winrm_timeout       = "6h"
  shutdown_command    = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  cpus                = 2
  memory              = 4096
  disk_size           = 61440
}

build {
  sources = [
    "source.vsphere-iso.windows11"
  ]

  provisioner "windows-shell" {
    script = "./scripts/your-script.ps1"
  }
}

