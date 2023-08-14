#Resource Group
resource "azurerm_resource_group" "main" {
  for_each = var.resource_groups
  name     = "cohort3-rg-${var.workload}-${var.environment}-${each.value.instance}"
  location = var.location
  tags     = var.tags
}

#Virtual Networks
module "virtual_network" {
  for_each            = var.vnet
  source              = "git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-virtual-network?ref=main"
  name                = "vnet-${each.key}-${var.location}-${each.value.instance}"
  resource_group_name = azurerm_resource_group.main[each.key].name
  location            = var.location
  vnet_address_space  = [each.value.vnet_address_space]
  depends_on          = [azurerm_resource_group.main]
}

#On_Prem Subnets
module "on-prem_subnet" {
  for_each                                  = var.on_prem_snet
  source                                    = "git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-subnet?ref=uyi"
  subnet_name                               = "snet-${each.key}-${var.location}"
  resource_group_name                       = azurerm_resource_group.main["on_prem"].name
  virtual_network_name                      = module.virtual_network["on_prem"].virtual_network.name
  address_prefixes                          = [each.value.address_prefixes]
  private_endpoint_network_policies_enabled = each.value.private_endpoint_network_policies_enabled
  depends_on                                = [module.virtual_network]
}

#Azure_Cloud Subnets    
module "azure_cloud_subnet" {
  for_each                                  = var.azure_cloud_snet
  source                                    = "git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-subnet?ref=uyi"
  subnet_name                               = "snet-${each.key}-${var.location}"
  resource_group_name                       = azurerm_resource_group.main["azure_cloud"].name
  virtual_network_name                      = module.virtual_network["azure_cloud"].virtual_network.name
  address_prefixes                          = [each.value.address_prefixes]
  private_endpoint_network_policies_enabled = each.value.private_endpoint_network_policies_enabled
  depends_on                                = [module.virtual_network]
}

#GatewaySubnet
module "gateway_subnet" {
  for_each                                  = var.gateway_subnet
  source                                    = "git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-subnet?ref=uyi"
  subnet_name                               = each.value.name
  resource_group_name                       = azurerm_resource_group.main[each.key].name
  virtual_network_name                      = module.virtual_network[each.key].virtual_network.name
  address_prefixes                          = [each.value.address_prefixes]
  private_endpoint_network_policies_enabled = each.value.private_endpoint_network_policies_enabled
  depends_on                                = [module.virtual_network]
}

#Network Security Group
resource "azurerm_network_security_group" "main" {
  for_each            = var.vnet
  name                = "nsg-${each.key}-${each.value.instance}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main[each.key].name

  tags = {
    environment = var.tags.Environment
  }
}

#Network Security Group Subnets Association On_Prem
resource "azurerm_subnet_network_security_group_association" "on_prem" {
  for_each                  = var.on_prem_snet
  subnet_id                 = module.on-prem_subnet[each.key].subnet_id
  network_security_group_id = azurerm_network_security_group.main["on_prem"].id
  depends_on                = [module.on-prem_subnet]
}

#Network Security Group Subnets Association Azure_Cloud
resource "azurerm_subnet_network_security_group_association" "azure_cloud" {
  for_each                  = var.azure_cloud_snet
  subnet_id                 = module.azure_cloud_subnet[each.key].subnet_id
  network_security_group_id = azurerm_network_security_group.main["azure_cloud"].id
  depends_on                = [module.azure_cloud_subnet]
}

resource "azurerm_network_security_rule" "on_prem" {
  for_each                    = var.NSG-Rules-on_prem
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.main["on_prem"].name
  network_security_group_name = azurerm_network_security_group.main["on_prem"].name
}

resource "azurerm_network_security_rule" "azure_cloud" {
  for_each                    = var.NSG-Rules-azure_cloud
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.main["azure_cloud"].name
  network_security_group_name = azurerm_network_security_group.main["azure_cloud"].name
}

#Private DNS Zone
resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  depends_on          = [azurerm_resource_group.main]
}

#Private DNS Zone Virtual Network Link 
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.vnet
  name                  = "${each.key}-dns_link"
  resource_group_name   = azurerm_resource_group.main["azure_cloud"].name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = module.virtual_network[each.key].virtual_network.id
  depends_on = [azurerm_private_dns_zone.this,
    azurerm_subnet_network_security_group_association.azure_cloud,
  azurerm_subnet_network_security_group_association.on_prem]
}


#Public IP for the Virtual Network Gateways
resource "azurerm_public_ip" "this" {
  for_each            = var.vnet
  name                = "pip-${each.key}-${var.environment}-${var.location}-${each.value.instance}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Virtual Network Gateways
module "virtual_network_gateway" {
  for_each            = var.vnet_gateway
  source              = "git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-vpn-gateway?ref=taofeek"
  vpn_gatway_name     = "vgw-${each.key}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main[each.key].name

  gateway_type = each.value.gateway_type
  vpn_type     = each.value.vpn_type
  sku          = each.value.sku

  public_ip_address_id          = azurerm_public_ip.this[each.key].id
  private_ip_address_allocation = each.value.private_ip_address_allocation
  subnet_id                     = module.gateway_subnet[each.key].subnet_id
  depends_on = [azurerm_subnet_network_security_group_association.on_prem,
  azurerm_subnet_network_security_group_association.azure_cloud]
}


#Virtual Network Gateways Connection On_prem to Azure Cloud
resource "azurerm_virtual_network_gateway_connection" "on_prem_to_azure_cloud" {
  for_each            = var.onprem_vnet_connection
  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.main["on_prem"].name

  type                            = each.value.type
  virtual_network_gateway_id      = module.virtual_network_gateway["on_prem"].vpn_network_gateway.id
  peer_virtual_network_gateway_id = module.virtual_network_gateway["azure_cloud"].vpn_network_gateway.id

  shared_key = each.value.shared_key
  depends_on = [azurerm_subnet_network_security_group_association.on_prem]
}

#Virtual Network Gateways Connection Azure Cloud to  On_prem
resource "azurerm_virtual_network_gateway_connection" "azure_cloud_to_on_prem" {
  for_each            = var.azure_vnet_connection
  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name

  type                            = each.value.type
  virtual_network_gateway_id      = module.virtual_network_gateway["azure_cloud"].vpn_network_gateway.id
  peer_virtual_network_gateway_id = module.virtual_network_gateway["on_prem"].vpn_network_gateway.id

  shared_key = each.value.shared_key
  depends_on = [azurerm_subnet_network_security_group_association.azure_cloud]
}

#The random password  
resource "random_password" "password" {
  for_each         = var.password
  length           = each.value.length
  special          = each.value.special
  override_special = each.value.override_special
}


data "azurerm_key_vault" "this" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}


#Key Vault Secret 
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.password
  name         = each.key
  value        = random_password.password[each.key].result
  key_vault_id = data.azurerm_key_vault.this.id
  depends_on   = [data.azurerm_key_vault.this]
}


#Key Vault Secret Key Data
data "azurerm_key_vault_secret" "this" {
  for_each     = var.password
  name         = each.key
  key_vault_id = data.azurerm_key_vault.this.id
  depends_on   = [data.azurerm_key_vault.this]
}


#MySQL Server for the Database
resource "azurerm_mysql_server" "this" {
  for_each                     = var.onprem_mysql_server
  name                         = "mysql-${var.workload}-${var.environment}"
  resource_group_name          = azurerm_resource_group.main["on_prem"].name
  location                     = var.location
  version                      = each.value.version
  administrator_login          = each.value.admin_login
  administrator_login_password = data.azurerm_key_vault_secret.this["sql"].value
  sku_name                     = each.value.sku_name
  ssl_enforcement_enabled      = each.value.ssl_enforcement_enabled
  depends_on                   = [data.azurerm_key_vault_secret.this]
}

#Onprem MySQL Database
resource "azurerm_mysql_database" "this" {
  for_each            = var.mysql_database
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.main["on_prem"].name
  server_name         = azurerm_mysql_server.this["mysql_server"].name
  charset             = each.value.charset
  collation           = each.value.collation
  depends_on          = [azurerm_mysql_server.this]
}


#Public IP for onprem jumpbox
resource "azurerm_public_ip" "onprem_pip" {
  for_each            = var.onprem_pip
  name                = "pip-${each.key}-${each.value.env}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["on_prem"].name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

#On prem Jumpbox Virtual Machine
module "onprem_instance" {
  for_each             = var.onprem_instance
  source               = "git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-virtual-machine?ref=vikkie"
  vm_name              = "vm-${each.key}-${each.value.instance}"
  resource_group_name  = azurerm_resource_group.main["on_prem"].name
  location             = var.location
  size                 = each.value.vm_size
  subnet_id            = module.on-prem_subnet[each.key].subnet_id
  admin_username       = each.value.admin_username
  admin_password       = data.azurerm_key_vault_secret.this["vm-onprem"].value
  caching              = each.value.caching
  storage_account_type = each.value.storage_account_type
  publisher            = each.value.publisher
  offer                = each.value.offer
  sku                  = each.value.sku
  os_version           = each.value.os_version
  public_ip_address_id = azurerm_public_ip.onprem_pip[each.key].id
  depends_on           = [data.azurerm_key_vault_secret.this]
}

#Public IP for Azure Cloud jumpbox
resource "azurerm_public_ip" "azurecloud_pip" {
  for_each            = var.azurecloud_pip
  name                = "pip-${each.key}-${each.value.env}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

#Network Interface Card Azure Cloud Jumpbox
resource "azurerm_network_interface" "azure_instance" {
  for_each            = var.azurecloud_instance
  name                = "nic-${each.key}-${each.value.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name

  ip_configuration {
    name                          = "ipconfig-${each.key}-${each.value.env}"
    subnet_id                     = module.azure_cloud_subnet[each.key].subnet_id
    private_ip_address_allocation = each.value.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.azurecloud_pip[each.key].id
  }
}


#Azure Cloud Jumpbox Virtual Machine
resource "azurerm_virtual_machine" "azure_instance" {
  for_each            = var.azurecloud_instance
  name                = "vm-${each.key}-${var.environment}-${each.value.instance}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  network_interface_ids = [
    azurerm_network_interface.azure_instance[each.key].id
  ]
  vm_size = each.value.vm_size

  delete_os_disk_on_termination = each.value.delete_os_disk_on_termination

  storage_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
  storage_os_disk {
    name              = "os-disk-${each.key}-${each.value.instance}"
    caching           = each.value.caching
    create_option     = each.value.create_option
    managed_disk_type = each.value.managed_disk_type
  }
  os_profile {
    computer_name  = each.value.computer_name
    admin_username = each.value.username
    admin_password = data.azurerm_key_vault_secret.this["vm-azurecloud"].value
  }
  os_profile_linux_config {
    disable_password_authentication = each.value.disable_password_authentication
  }
  tags = {
    Environment = var.environment
  }
  depends_on = [data.azurerm_key_vault_secret.this]
}


#Private DNS Zone MySQL Server 
resource "azurerm_private_dns_zone" "mysql" {
  name                = var.mysql_dns_name
  resource_group_name = azurerm_resource_group.main["on_prem"].name
  depends_on          = [azurerm_resource_group.main]
}
#MySQL Server Private DNS Zone Virtual Network Link 
resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns_link"
  resource_group_name   = azurerm_resource_group.main["on_prem"].name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = module.virtual_network["on_prem"].virtual_network.id
  depends_on = [azurerm_private_dns_zone.mysql,
    azurerm_subnet_network_security_group_association.azure_cloud,
  azurerm_subnet_network_security_group_association.on_prem]
}

#Private DNS Zone Key Vault 
resource "azurerm_private_dns_zone" "keyvault" {
  name                = var.keyvault_dns_name
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  depends_on          = [azurerm_resource_group.main]
}
#Key Vault Private DNS Zone Virtual Network Link 
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "keyvault-dns_link"
  resource_group_name   = azurerm_resource_group.main["azure_cloud"].name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = module.virtual_network["azure_cloud"].virtual_network.id
  depends_on = [azurerm_private_dns_zone.keyvault,
    azurerm_subnet_network_security_group_association.azure_cloud,
  azurerm_subnet_network_security_group_association.on_prem]
}

#Private DNS Zone AKS Cluster
resource "azurerm_private_dns_zone" "aks_cluster" {
  name                = var.akscluster_dns_name
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  depends_on          = [azurerm_resource_group.main]
}
#AKS Cluster Private DNS Zone Virtual Network Link 
resource "azurerm_private_dns_zone_virtual_network_link" "aks_cluster" {
  name                  = "akscluster-dns_link"
  resource_group_name   = azurerm_resource_group.main["azure_cloud"].name
  private_dns_zone_name = azurerm_private_dns_zone.aks_cluster.name
  virtual_network_id    = module.virtual_network["azure_cloud"].virtual_network.id
  depends_on = [azurerm_private_dns_zone.aks_cluster,
    azurerm_subnet_network_security_group_association.azure_cloud,
  azurerm_subnet_network_security_group_association.on_prem]
}


#Private Endpoint for  Key Vault
resource "azurerm_private_endpoint" "key_vault" {
  name                = "pep-vault-${var.environment}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  subnet_id           = module.azure_cloud_subnet["key_vault"].subnet_id
  private_service_connection {
    name                           = "keyvault-private-endpoint"
    is_manual_connection           = false
    private_connection_resource_id = data.azurerm_key_vault.this.id
    subresource_names              = ["vault"]
  }
  private_dns_zone_group {
    name                 = "keyvault-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }
  depends_on = [azurerm_private_dns_zone.keyvault,
  data.azurerm_key_vault.this, module.azure_cloud_subnet]
}


#private endpoint for MySQL Database
resource "azurerm_private_endpoint" "mysql_server" {
  for_each            = var.onprem_mysql_server
  name                = "pep-${each.key}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["on_prem"].name
  subnet_id           = module.on-prem_subnet["sql"].subnet_id
  private_service_connection {
    name                           = "mysql-private-endpoint"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mysql_server.this[each.key].id
    subresource_names              = ["mysqlServer"]
  }
  private_dns_zone_group {
    name                 = "mysql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysql.id]
  }
  depends_on = [module.on-prem_subnet, azurerm_mysql_server.this,
  azurerm_private_dns_zone.mysql]
}

#private endpoint for AKS Cluster
resource "azurerm_private_endpoint" "aks_cluster" {
  for_each            = var.azure_aks_cluster
  name                = "pep-${each.key}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  subnet_id           = module.azure_cloud_subnet[each.key].subnet_id
  #subnet_id = each.value.dns_service_ip
  private_service_connection {
    name                           = "akscluster-private-endpoint"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_kubernetes_cluster.this[each.key].id
    subresource_names              = ["management"]
  }
  private_dns_zone_group {
    name                 = "akscluster-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.aks_cluster.id]
  }
  depends_on = [module.azure_cloud_subnet, azurerm_kubernetes_cluster.this,
  azurerm_private_dns_zone.aks_cluster]
}


#Azure Storage
data "azurerm_storage_account" "this" {
  name                = var.azure_storage_name
  resource_group_name = var.resource_group_name
}



#Azure Kubernetes Service Cluster
resource "azurerm_kubernetes_cluster" "this" {
  for_each            = var.azure_aks_cluster
  name                = "${each.value.prefix}-k8s"
  location            = var.location
  resource_group_name = azurerm_resource_group.main["azure_cloud"].name
  dns_prefix          = "${each.value.prefix}-k8s"
  default_node_pool {
    name           = each.value.node_name
    node_count     = each.value.node_count
    vm_size        = each.value.vm_size
    vnet_subnet_id = module.azure_cloud_subnet["aks_cluster"].subnet_id
  }
  windows_profile {
    admin_username = each.value.admin_username
    admin_password = each.value.admin_password
  }
  network_profile {
    network_plugin    = each.value.network_plugin
    load_balancer_sku = each.value.load_balancer_sku
    service_cidr      = each.value.service_cidr
    dns_service_ip    = each.value.dns_service_ip
  }
  private_cluster_enabled = each.value.private_cluster_enabled

  identity {
    type = each.value.type
  }
  tags = var.tags
}


# Azure Monitor Diagnostic for Key Vault
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  for_each           = var.keyvault_monitor
  name               = "${each.key}-diagnostic"
  target_resource_id = data.azurerm_key_vault.this.id
  storage_account_id = data.azurerm_storage_account.this.id
  enabled_log {
    category = each.value.log_category

    retention_policy {
      enabled = each.value.log_rention_policy
    }
  }

  metric {
    category = each.value.metric_category

    retention_policy {
      enabled = each.value.metric_rention_policy
    }
  }
}


# Azure Monitor Diagnostic for MySQL Server
resource "azurerm_monitor_diagnostic_setting" "mysql_server" {
  for_each           = var.mysqlserver_monitor
  name               = "${each.key}-diagnostic"
  target_resource_id = azurerm_mysql_server.this[each.key].id
  storage_account_id = data.azurerm_storage_account.this.id
  enabled_log {
    category = each.value.log_category

    retention_policy {
      enabled = each.value.log_rention_policy
    }
  }

  metric {
    category = each.value.metric_category

    retention_policy {
      enabled = each.value.metric_rention_policy
    }
  }
}

# Azure Monitor Diagnostic for AKS Cluster
resource "azurerm_monitor_diagnostic_setting" "aks_cluster" {
  for_each           = var.akscluster_monitor
  name               = "${each.key}-diagnostic"
  target_resource_id = azurerm_kubernetes_cluster.this[each.key].id
  storage_account_id = data.azurerm_storage_account.this.id
  enabled_log {
    category = each.value.log_category

    retention_policy {
      enabled = each.value.log_rention_policy
    }
  }

  metric {
    category = each.value.metric_category

    retention_policy {
      enabled = each.value.metric_rention_policy
    }
  }
}
