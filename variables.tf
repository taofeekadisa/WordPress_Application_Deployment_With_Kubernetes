#Resource group
variable "resource_groups" {
  type = map(object({
    instance = string
  }))
}
#Loaction
variable "location" {
  description = "Location of the resource group."
  type        = string
}

#Tags
variable "tags" {
  description = "Tags to associate with the resource group."
  type        = map(string)
}

#Environment
variable "environment" {
  type = string
}

#Workload
variable "workload" {
  type = string
}

#Virtual Network
variable "vnet" {
  type = map(object({
    instance           = string
    vnet_address_space = string
  }))
}

#On_Prem Subnet
variable "on_prem_snet" {
  type = map(object({
    address_prefixes                          = string
    private_endpoint_network_policies_enabled = bool
  }))
}

#Azure_Cloud Subnet
variable "azure_cloud_snet" {
  type = map(object({
    address_prefixes                          = string
    private_endpoint_network_policies_enabled = bool

  }))
}

#Gateway Subnet
variable "gateway_subnet" {
  type = map(object({
    name                                      = string
    address_prefixes                          = string
    private_endpoint_network_policies_enabled = bool

  }))
}

# #NGS rules on_prem
variable "NSG-Rules-on_prem" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = number
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "NSG rules for on-premises network"
}

# #NGS rules azure_cloud
variable "NSG-Rules-azure_cloud" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = number
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "NSG rules for Azure Cloud"
}

#Private DNS Zone
variable "private_dns_zone" {
  type        = string
  description = "The name of the Private DNS Zone virtual network link"
}

#Private DNS Zone Link
variable "private_dns_link" {
  type        = string
  description = " The name of the Private DNS Zone Virtual Network Link"
}

#Virtual Network Gateways
variable "vnet_gateway" {
  type = map(object({
    gateway_type                  = string
    vpn_type                      = string
    sku                           = string
    private_ip_address_allocation = string
  }))
}

#Virtual Network Gateways Connection On_prem to Azure Cloud
variable "onprem_vnet_connection" {
  type = map(object({
    name       = string
    type       = string
    shared_key = string
  }))
}

#Virtual Network Gateways Connection Azure Cloud to  On_prem
variable "azure_vnet_connection" {
  type = map(object({
    name       = string
    type       = string
    shared_key = string
  }))
}

#Random password
variable "password" {
  type = map(object({
    length           = number
    special          = bool
    override_special = string
  }))
}

#Key vault
variable "keyvault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}


#Object ID
variable "object_id" {
  type = string
}


# Public IP for onprem Jumpbox
variable "onprem_pip" {
  type = map(object({
    allocation_method = string
    sku               = string
    env               = string
  }))
}

#On prem Jumpbox Virtual Machine
variable "onprem_instance" {
  type = map(object({
    vm_size        = string
    admin_username = string
    #admin_password       = string
    caching              = string
    storage_account_type = string
    publisher            = string
    offer                = string
    sku                  = string
    os_version           = string
    instance             = string
  }))
}


#Public IP for Azure Cloud jumpbox
variable "azurecloud_pip" {
  type = map(object({
    allocation_method = string
    sku               = string
    env               = string
  }))
}


#Azure Cloud Jumpbox Virtual Machine
variable "azurecloud_instance" {
  type = map(object({
    instance                        = string
    username                        = string
    vm_size                         = string
    delete_os_disk_on_termination   = bool
    publisher                       = string
    offer                           = string
    sku                             = string
    version                         = string
    caching                         = string
    create_option                   = string
    managed_disk_type               = string
    computer_name                   = string
    disable_password_authentication = bool
    private_ip_address_allocation   = string
    env                             = string
  }))
}
#MySQL Server
variable "onprem_mysql_server" {
  type = map(object({
    admin_login = string
    #admin_login_password    = string
    sku_name                = string
    version                 = string
    ssl_enforcement_enabled = bool
  }))

}

#Database in MySQL Server
variable "mysql_database" {
  type = map(object({
    charset   = string
    collation = string
  }))
}

#Azure Storage
variable "azure_storage_name" {
  type = string
}


#Azure Kubernetes Service Cluster
variable "azure_aks_cluster" {
  type = map(object({
    prefix                  = string
    node_name               = string
    node_count              = number
    vm_size                 = string
    admin_username          = string
    admin_password          = string
    type                    = string
    network_plugin          = string
    load_balancer_sku       = string
    service_cidr            = string
    dns_service_ip          = string
    private_cluster_enabled = bool
  }))
}

# Azure Monitor Diagnostic for Key Vault
variable "keyvault_monitor" {
  type = map(object({
    log_category          = string
    log_rention_policy    = bool
    metric_category       = string
    metric_rention_policy = bool
  }))
}


# Azure Monitor Diagnostic MySQL Server
variable "mysqlserver_monitor" {
  type = map(object({
    log_category          = string
    log_rention_policy    = bool
    metric_category       = string
    metric_rention_policy = bool
  }))
}

# Azure Monitor Diagnostic for AKS Cluste
variable "akscluster_monitor" {
  type = map(object({
    log_category          = string
    log_rention_policy    = bool
    metric_category       = string
    metric_rention_policy = bool
  }))
}

#Private DNS Zone MySQL Server
variable "mysql_dns_name" {
  type = string
}

#Private DNS Zone Key Vault
variable "keyvault_dns_name" {
  type = string
}

#Private DNS Zone AKS Cluster
variable "akscluster_dns_name" {
  type = string
}
