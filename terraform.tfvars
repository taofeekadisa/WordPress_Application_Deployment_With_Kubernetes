#Resource group
resource_groups = {
  on_prem = {
    instance = "001"
  }
  azure_cloud = {
    instance = "002"
  }
}

#Loaction
location = "eastus2"

#Tags
tags = {
  Owner        = "Immersion"
  Date_Created = "2023-06-26"
  Environment  = "dev"
}

#Environment
environment = "dev"

#Workload
workload = "capstone"

#Virtual Network
vnet = {
  on_prem = {
    instance           = "001"
    vnet_address_space = "172.0.0.0/16"
  }
  azure_cloud = {
    instance           = "002"
    vnet_address_space = "10.0.0.0/16"
  }
}

#On_Prem Subnet
on_prem_snet = {
  sql = {
    address_prefixes                          = "172.0.0.0/24"
    private_endpoint_network_policies_enabled = true

  }
  jumpbox = {
    address_prefixes                          = "172.0.1.0/24"
    private_endpoint_network_policies_enabled = false
  }
}

#Azure_Cloud Subnet
azure_cloud_snet = {
  aks_cluster = {
    address_prefixes                          = "10.0.4.0/24"
    private_endpoint_network_policies_enabled = true
  }
  jumpbox = {
    address_prefixes                          = "10.0.1.0/24"
    private_endpoint_network_policies_enabled = false
  }
  storage_account = {
    address_prefixes                          = "10.0.2.0/24"
    private_endpoint_network_policies_enabled = false
  }
  key_vault = {
    address_prefixes                          = "10.0.0.0/24"
    private_endpoint_network_policies_enabled = true
  }
}

#Gateway Subnet
gateway_subnet = {
  on_prem = {
    name                                      = "GatewaySubnet"
    address_prefixes                          = "172.0.2.0/24"
    private_endpoint_network_policies_enabled = false

  }
  azure_cloud = {
    name                                      = "GatewaySubnet"
    address_prefixes                          = "10.0.10.0/24"
    private_endpoint_network_policies_enabled = false
  }
}

#NSG rules on_prem
NSG-Rules-on_prem = {
  internet_to_jumpbox = {
    name                       = "allow-internet-access-to-jumpbox"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "172.0.1.0/24"
  }
  rdp_to_jumpbox = {
    name                       = "allow-rdp-inbound-to-jumpbox"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "172.0.1.0/24"
  }
}


#NGS rule azure_cloud
NSG-Rules-azure_cloud = {
  internet_to_jumpbox = {
    name                       = "allow-internet-access-to-jumpbox"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
  ssh_to_jumpbox = {
    name                       = "allow-ssh-to-jumpbox"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
}


#Private DNS Zone
private_dns_zone = "capstone.dns"

#Private DNS Zone Link
private_dns_link = "priv-dns-vnet-link"

#Virtual Network Gateways
vnet_gateway = {
  on_prem = {
    gateway_type                  = "Vpn"
    vpn_type                      = "RouteBased"
    sku                           = "VpnGw1"
    private_ip_address_allocation = "Dynamic"
  }
  azure_cloud = {
    gateway_type                  = "Vpn"
    vpn_type                      = "RouteBased"
    sku                           = "VpnGw1"
    private_ip_address_allocation = "Dynamic"
  }
}


#Virtual Network Gateways Connection On_prem to Azure Cloud
onprem_vnet_connection = {
  on_prem = {
    name       = "on_prem-azure_cloud"
    type       = "Vnet2Vnet"
    shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  }
}

#Virtual Network Gateways Connection Azure Cloud to  On_prem
azure_vnet_connection = {
  azure_cloud = {
    name       = "azure_cloud-on_prem"
    type       = "Vnet2Vnet"
    shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  }
}

#random password for vms
password = {
  vm-onprem = {
    length           = 16
    special          = true
    override_special = "!#$%&@"
  }
  vm-azurecloud = {
    length           = 16
    special          = true
    override_special = "!#$%&@"
  }
  sql = {
    length           = 16
    special          = true
    override_special = "!#$%&*()-_=+[]{}<>:?"
  }
  shared-key = {
    length           = 16
    special          = true
    override_special = "-"
  }
}
#Key vault
keyvault_name       = "vault-capstone-01"
resource_group_name = "cohort3-rg-immersion-dev"


#Object ID
object_id = "5007c4a7-078d-4779-a4be-8a39bfc4c7f5"

#Public IP for onprem jumpbox
onprem_pip = {
  jumpbox = {
    allocation_method = "Static"
    sku               = "Standard"
    env               = "onprem"
  }
}


#On prem Jumpbox Virtual Machine
onprem_instance = {
  jumpbox = {
    vm_size        = "Standard_B2ms"
    admin_username = "adminuser"
    #admin_password       = "P@$$w0rd1234!"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    publisher            = "MicrosoftWindowsServer"
    offer                = "WindowsServer"
    sku                  = "2016-Datacenter"
    os_version           = "latest"
    instance             = "001"
  }
}


#Public IP for onprem jumpbox
azurecloud_pip = {
  jumpbox = {
    allocation_method = "Static"
    sku               = "Standard"
    env               = "azure"
  }
}

#Azure Cloud Jumpbox Virtual Machine
azurecloud_instance = {
  jumpbox = {
    instance                        = "002"
    username                        = "adminuser"
    vm_size                         = "Standard_B1s"
    delete_os_disk_on_termination   = true
    publisher                       = "Canonical"
    offer                           = "0001-com-ubuntu-server-focal"
    sku                             = "20_04-lts"
    version                         = "latest"
    caching                         = "ReadWrite"
    create_option                   = "FromImage"
    managed_disk_type               = "Standard_LRS"
    computer_name                   = "hostname"
    disable_password_authentication = false
    private_ip_address_allocation   = "Dynamic"
    env                             = "azure"
  }
}


#MySQL Server
onprem_mysql_server = {
  mysql_server = {
    admin_login             = "adminuser"
    sku_name                = "GP_Gen5_2"
    ssl_enforcement_enabled = true
    version                 = "8.0"
  }
}

#MySQL Server Database
mysql_database = {
  sql = {
    charset   = "utf8"
    collation = "utf8_unicode_ci"
  }
}

#Azure Storage
azure_storage_name = "capstone4321"


#Azure Kubernetes Service Cluster
azure_aks_cluster = {
  aks_cluster = {
    prefix                  = "wordpress"
    node_name               = "system"
    node_count              = 1
    vm_size                 = "Standard_DS3_v2"
    admin_username          = "adminuser"
    admin_password          = "KnixatP@$$w0rd1234!"
    type                    = "SystemAssigned"
    network_plugin          = "azure"
    load_balancer_sku       = "standard"
    service_cidr            = "10.1.0.0/16"
    dns_service_ip          = "10.1.0.10"
    private_cluster_enabled = true
  }
}

# Azure Monitor Diagnostic for Key Vault
keyvault_monitor = {
  key_vault = {
    log_category          = "AuditEvent"
    log_rention_policy    = true
    metric_category       = "AllMetrics"
    metric_rention_policy = true
  }
}

# Azure Monitor Diagnostic MySQL Server
mysqlserver_monitor = {
  mysql_server = {
    log_category          = "MySqlSlowLogs"
    log_rention_policy    = true
    metric_category       = "AllMetrics"
    metric_rention_policy = true
  }
}

# Azure Monitor Diagnostic MySQL Server
akscluster_monitor = {
  aks_cluster = {
    log_category          = "kube-audit"
    log_rention_policy    = true
    metric_category       = "AllMetrics"
    metric_rention_policy = true
  }
}


#Private DNS Zone MySQL Server
mysql_dns_name = "privatelink.mysql.database.azure.com"

#Private DNS Zone MySQL Server
keyvault_dns_name = "privatelink.vaultcore.azure.net"

#Private DNS Zone AKS Cluster
akscluster_dns_name = "privatelink.eastus2.azmk8s.io"
