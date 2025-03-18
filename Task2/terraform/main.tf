terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.74"
}

provider "yandex" {
  zone = "ru-central1-d"
}

resource "yandex_compute_disk" "boot-disk" {
  name     = "general"
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = "20"
  image_id = "fd8kc2n656prni2cimp5"
  folder_id = "${var.yc_folder_id}"
}

resource "yandex_compute_instance" "vm-1" {
  name                      = "minikube"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = "ru-central1-d"

  resources {
    cores  = "2"
    memory = "4"
    core_fraction = "5"
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "<>:<>"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
  folder_id = "${var.yc_folder_id}"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-d"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

variable "yc_folder_id" {
  type = string
}

output "instance_external_ip" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}