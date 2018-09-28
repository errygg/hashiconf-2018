terraform {
  required_version = ">= 0.11.5"
}

resource "azurerm_resource_group" "networking" {
  name     = "${var.namespace}-network-resource-group"
  location = "${var.location}"

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.namespace}-virtual-network"
  address_space       = ["${var.network_space}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_public_ip" "consul" {
  count = "${var.enable_consul}"

  name                         = "consul-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.networking.name}"
  public_ip_address_allocation = "static"

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_public_ip" "nomad" {
  count = "${var.enable_nomad}"

  name                         = "nomad-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.networking.name}"
  public_ip_address_allocation = "static"

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_public_ip" "vault" {
  count = "${var.enable_vault}"

  name                         = "vault-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.networking.name}"
  public_ip_address_allocation = "static"

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_lb" "consul" {
  count = "${var.enable_consul}"

  name                = "consul-public-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"

  frontend_ip_configuration {
    name                 = "consul-lb-ip"
    public_ip_address_id = "${azurerm_public_ip.consul.id}"
  }

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_lb" "nomad" {
  count = "${var.enable_nomad}"

  name                = "nomad-public-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"

  frontend_ip_configuration {
    name                 = "nomad-lb-ip"
    public_ip_address_id = "${azurerm_public_ip.nomad.id}"
  }

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_lb" "vault" {
  count = "${var.enable_vault}"

  name                = "vault-public-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"

  frontend_ip_configuration {
    name                 = "vault-lb-ip"
    public_ip_address_id = "${azurerm_public_ip.vault.id}"
  }

  tags = "${merge(var.tags, map("Name", format("%s", var.namespace)))}"
}

resource "azurerm_lb_backend_address_pool" "consul" {
  count = "${var.enable_consul}"

  name                = "consul-lb-backend-pool"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  loadbalancer_id     = "${azurerm_lb.consul.id}"
}

resource "azurerm_lb_backend_address_pool" "nomad" {
  count = "${var.enable_nomad}"

  name                = "nomad-lb-backend-pool"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  loadbalancer_id     = "${azurerm_lb.nomad.id}"
}

resource "azurerm_lb_backend_address_pool" "vault" {
  count = "${var.enable_vault}"
  
  name                = "vault-lb-backend-pool"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  loadbalancer_id     = "${azurerm_lb.vault.id}"
}
