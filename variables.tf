variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  default     = "DevOpsRG"
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  default     = "East US"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  default     = "myAKSCluster"
}

variable "aks_node_count" {
  description = "The number of nodes in the AKS cluster."
  default     = 2
}

variable "aks_node_vm_size" {
  description = "The size of the virtual machines in the AKS node pool."
  default     = "Standard_DS2_v2"
}

variable "sql_server_name" {
  description = "The name of the Azure SQL Server."
  default     = "my-newsql-server"
}

variable "sql_database_name" {
  description = "The name of the Azure SQL Database."
  default     = "mySqlDatabase"
}

variable "sql_admin_password" {
  description = "The password for the SQL Server administrator."
  default     = "Pa$$word1234!" 
}


variable "vnet_name" {
  description = "The name of the Azure Virtual Network."
  default     = "aks-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the Azure Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the subnet."
  default     = "aks-subnet"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
