# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Include variables from variables.tf
# variable "resource_group_name" {}
# variable "location" {}
# variable "aks_cluster_name" {}

# Define Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network for AKS
resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

# Define AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_cluster_name
  kubernetes_version  = "1.29.0"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.2.0.0/16"
    dns_service_ip = "10.2.0.10"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Define Azure SQL Server
resource "azurerm_sql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
}

# Define Azure SQL Database
resource "azurerm_sql_database" "sql_db" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql_server.name
}

# Include outputs from outputs.tf
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}

output "sql_database_id" {
  value = azurerm_sql_database.sql_db.id
}

output "sql_database_connection_string" {
  value = "Server=tcp://${azurerm_sql_server.sql_server.fully_qualified_domain_name};Database=${azurerm_sql_database.sql_db.name};User ID=sqladmin@${azurerm_sql_server.sql_server.name};Password=${var.sql_admin_password};Encrypt=true;Connection Timeout=30;"
}
