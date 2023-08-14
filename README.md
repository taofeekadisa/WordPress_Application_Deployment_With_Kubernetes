## Project Documentation

## Deployment of WordPress Website with AKS Cluster on Azure


### Architecture Diagram:
![diagram](https://github.com/praisephs/deployment-of-3-VMs-using-azure-storage-for-tfstate/assets/129758959/0e5c53d7-a0b3-4c66-9521-a5eba07f293d)


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.62.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.62.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

This document provides an overview of the project and describes the Terraform configuration used to deploy the infrastructure resources in Azure.

### Overview

The following infrastructures were provisioned on Azure_Cloud and On_Prem

- Virtual Networks
- Virtual Network Gateways
- Key Vault
- MySQL Server
- MySQL Databases
- Jumpbox Virtual Machine
- Azure Storage
- Azure Kubernetes Service (AKS) Cluster
- Azure Monitor Diagnostics

 ### Tools Used
- Azure portal
- VS Code terminal
- Azure CLI
- Terraform
- Distributed version control system(Git)
- GitHub Actions
  

### Terraform Modules

The project uses Terraform modules to define and provision the infrastructure resources. 

## Resources 

1. #####  azurerm_resource_group.this

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | name of the resource group. | `string` | `"cohort3-rg-knixat-dev"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to associate with the resource group. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rg_id"></a> [rg\_id](#output\_rg\_id) | n/a |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | n/a |
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | n/a |


2. ##### azurerm_virtual_network.this

| Name | Type |
|------|------|
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the virtual network. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of virtual network | `string` | `"vnet-test"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the virtual network will be created. | `string` | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Address space of the virtual network. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_network"></a> [virtual\_network](#output\_virtual\_network) | n/a |


3. ##### azurerm_subnet_main

| Name | Type |
|------|------|
| [azurerm_subnet.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | address prefix for subnet number | `list(string)` | <pre>[<br>  "10.0.0.0/24"<br>]</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the subnet | `string` | `"cohort3-rg-immersion-dev-001"` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | service endpoint to associate with the subnet | `list(string)` | <pre>[<br>  "Microsoft.sql"<br>]</pre> | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet | `string` | `"snet-dev-eastus2-001"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | virtual network name | `string` | `"vnet-dev-eastus2-001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_snet_address_prefixes_output"></a> [snet\_address\_prefixes\_output](#output\_snet\_address\_prefixes\_output) | n/a |
| <a name="output_snet_name_output"></a> [snet\_name\_output](#output\_snet\_name\_output) | n/a |
| <a name="output_snet_service_endpoints-output"></a> [snet\_service\_endpoints-output](#output\_snet\_service\_endpoints-output) | n/a |



3. ##### azurerm_windows_virtual_machine.this

| Name | Type |
|------|------|
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_MicrosoftWindowsServer"></a> [MicrosoftWindowsServer](#input\_MicrosoftWindowsServer) | n/a | `any` | n/a | yes |
| <a name="input_WindowsServer"></a> [WindowsServer](#input\_WindowsServer) | n/a | `any` | n/a | yes |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | n/a | `any` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | n/a | `any` | n/a | yes |
| <a name="input_caching"></a> [caching](#input\_caching) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | project environment | `string` | n/a | yes |
| <a name="input_ip-name"></a> [ip-name](#input\_ip-name) | ip configuration name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the resources will be deployed | `string` | n/a | yes |
| <a name="input_network_interface_ids"></a> [network\_interface\_ids](#input\_network\_interface\_ids) | network interface ids | `string` | n/a | yes |
| <a name="input_nic-name"></a> [nic-name](#input\_nic-name) | Name of the network interface card | `string` | n/a | yes |
| <a name="input_offer"></a> [offer](#input\_offer) | offer | `string` | n/a | yes |
| <a name="input_os_version"></a> [os\_version](#input\_os\_version) | Version of the VM image | `string` | n/a | yes |
| <a name="input_private_ip_address_allocation"></a> [private\_ip\_address\_allocation](#input\_private\_ip\_address\_allocation) | association of the private ip | `string` | `"Dynamic"` | no |
| <a name="input_publisher"></a> [publisher](#input\_publisher) | Publisher of the VM image | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | n/a | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | `any` | n/a | yes |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | n/a | `any` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet where the NIC will be attached | `string` | n/a | yes |
| <a name="input_version"></a> [version](#input\_version) | n/a | `any` | n/a | yes |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | n/a | `any` | n/a | yes |
| <a name="input_vm-name"></a> [vm-name](#input\_vm-name) | Name of the virtual machine | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | n/a | `any` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | the project being worked on | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_windows_virtual_machine"></a> [azurerm\_windows\_virtual\_machine](#output\_azurerm\_windows\_virtual\_machine) | n/a |
| <a name="output_nic-ids"></a> [nic-ids](#output\_nic-ids) | n/a |


4. ##### azurerm_virtual_network_gateway.main

| Name | Type |
|------|------|
| [azurerm_virtual_network_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway_type"></a> [gateway\_type](#input\_gateway\_type) | The virtual network gateway connection type | `string` | `"Vpn"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the connection is located. | `string` | n/a | yes |
| <a name="input_private_ip_address_allocation"></a> [private\_ip\_address\_allocation](#input\_private\_ip\_address\_allocation) | Private ip address allocation type | `string` | `"Dynamic"` | no |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | n/a | `string` | `"The id of the public ip address"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the connection Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Configuration of the size and capacity of the virtual network gateway. | `string` | `"Basic"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet | `string` | n/a | yes |
| <a name="input_vpn_gatway_name"></a> [vpn\_gatway\_name](#input\_vpn\_gatway\_name) | The name of the connection | `string` | n/a | yes |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | The vpn type of the virtual network gateway | `string` | `"RoutBased"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpn_network_gateway"></a> [vpn\_network\_gateway](#output\_vpn\_network\_gateway) | n/a |


### Usage

To use the Terraform configuration, follow these steps:

1. Install Terraform: Ensure that Terraform is installed on your local machine.
2. Clone the Terraform configuration: Clone the repository containing the Terraform configuration files.
3. Configure variables: Modify the variables in the configuration files according to your requirements.
4. Initialize Terraform: Run `terraform init` to initialize the Terraform working directory.
5. Plan the deployment: Run `terraform plan` to review the planned changes and resource creations.
6. Deploy the infrastructure: Run `terraform apply` to apply the changes and provision the infrastructure resources.
7. Verify the deployment: Validate that all the resources are successfully provisioned in the Azure portal.
8. CI/CD pipeline was also created for automation using a workflow to create YAML files for terraform plan(triggered when there is a push or pull request to the repo, terraform apply(triggered during a merge request) and terraform destroy(this uses a workflow dispatch event and done manually)
   

## cloud-immersion062023-capstone

| Name | Source |
|------|--------|
| <a name="module_azure_cloud_subnet"></a> [azure\_cloud\_subnet](#module\_azure\_cloud\_subnet) | git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-subnet | uyi |
| <a name="module_gateway_subnet"></a> [gateway\_subnet](#module\_gateway\_subnet) | git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-subnet | uyi |
| <a name="module_on-prem_subnet"></a> [on-prem\_subnet](#module\_on-prem\_subnet) | git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-subnet | uyi |
| <a name="module_onprem_instance"></a> [onprem\_instance](#module\_onprem\_instance) | git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-virtual-machine | vikkie |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-virtual-network | main |
| <a name="module_virtual_network_gateway"></a> [virtual\_network\_gateway](#module\_virtual\_network\_gateway) | git::https://github.com/knixat/terraform-modules.git//modules/terraform-azurerm-vpn-gateway | taofeek |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/key_vault_secret) | resource |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/kubernetes_cluster) | resource |
| [azurerm_monitor_diagnostic_setting.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_mysql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/mysql_database) | resource |
| [azurerm_mysql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/mysql_server) | resource |
| [azurerm_network_interface.azure_instance](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.azure_cloud](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.on_prem](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.mysql](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.mysql](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.azurecloud_pip](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/public_ip) | resource |
| [azurerm_public_ip.onprem_pip](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/public_ip) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/public_ip) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/resource_group) | resource |
| [azurerm_subnet_network_security_group_association.azure_cloud](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.on_prem](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_machine.azure_instance](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/virtual_machine) | resource |
| [azurerm_virtual_network_gateway_connection.azure_cloud_to_on_prem](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/virtual_network_gateway_connection) | resource |
| [azurerm_virtual_network_gateway_connection.on_prem_to_azure_cloud](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/resources/virtual_network_gateway_connection) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/password) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/data-sources/key_vault_secret) | data source |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.62.1/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_NSG-Rules-azure_cloud"></a> [NSG-Rules-azure\_cloud](#input\_NSG-Rules-azure\_cloud) | NSG rules for Azure Cloud | <pre>map(object({<br>    name                       = string<br>    priority                   = number<br>    direction                  = string<br>    access                     = string<br>    protocol                   = string<br>    source_port_range          = string<br>    destination_port_range     = number<br>    source_address_prefix      = string<br>    destination_address_prefix = string<br>  }))</pre> | n/a | yes |
| <a name="input_NSG-Rules-on_prem"></a> [NSG-Rules-on\_prem](#input\_NSG-Rules-on\_prem) | NSG rules for on-premises network | <pre>map(object({<br>    name                       = string<br>    priority                   = number<br>    direction                  = string<br>    access                     = string<br>    protocol                   = string<br>    source_port_range          = string<br>    destination_port_range     = number<br>    source_address_prefix      = string<br>    destination_address_prefix = string<br>  }))</pre> | n/a | yes |
| <a name="input_akscluster_dns_name"></a> [akscluster\_dns\_name](#input\_akscluster\_dns\_name) | Private DNS Zone AKS Cluster | `string` | n/a | yes |
| <a name="input_akscluster_monitor"></a> [akscluster\_monitor](#input\_akscluster\_monitor) | Azure Monitor Diagnostic for AKS Cluste | <pre>map(object({<br>    log_category          = string<br>    log_rention_policy    = bool<br>    metric_category       = string<br>    metric_rention_policy = bool<br>  }))</pre> | n/a | yes |
| <a name="input_azure_aks_cluster"></a> [azure\_aks\_cluster](#input\_azure\_aks\_cluster) | Azure Kubernetes Service Cluster | <pre>map(object({<br>    prefix                  = string<br>    node_name               = string<br>    node_count              = number<br>    vm_size                 = string<br>    admin_username          = string<br>    admin_password          = string<br>    type                    = string<br>    network_plugin          = string<br>    load_balancer_sku       = string<br>    service_cidr            = string<br>    dns_service_ip          = string<br>    private_cluster_enabled = bool<br>  }))</pre> | n/a | yes |
| <a name="input_azure_cloud_snet"></a> [azure\_cloud\_snet](#input\_azure\_cloud\_snet) | Azure\_Cloud Subnet | <pre>map(object({<br>    address_prefixes                          = string<br>    private_endpoint_network_policies_enabled = bool<br><br>  }))</pre> | n/a | yes |
| <a name="input_azure_storage_name"></a> [azure\_storage\_name](#input\_azure\_storage\_name) | Azure Storage | `string` | n/a | yes |
| <a name="input_azure_vnet_connection"></a> [azure\_vnet\_connection](#input\_azure\_vnet\_connection) | Virtual Network Gateways Connection Azure Cloud to  On\_prem | <pre>map(object({<br>    name       = string<br>    type       = string<br>    shared_key = string<br>  }))</pre> | n/a | yes |
| <a name="input_azurecloud_instance"></a> [azurecloud\_instance](#input\_azurecloud\_instance) | Azure Cloud Jumpbox Virtual Machine | <pre>map(object({<br>    instance                        = string<br>    username                        = string<br>    vm_size                         = string<br>    delete_os_disk_on_termination   = bool<br>    publisher                       = string<br>    offer                           = string<br>    sku                             = string<br>    version                         = string<br>    caching                         = string<br>    create_option                   = string<br>    managed_disk_type               = string<br>    computer_name                   = string<br>    disable_password_authentication = bool<br>    private_ip_address_allocation   = string<br>    env                             = string<br>  }))</pre> | n/a | yes |
| <a name="input_azurecloud_pip"></a> [azurecloud\_pip](#input\_azurecloud\_pip) | Public IP for Azure Cloud jumpbox | <pre>map(object({<br>    allocation_method = string<br>    sku               = string<br>    env               = string<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_gateway_subnet"></a> [gateway\_subnet](#input\_gateway\_subnet) | Gateway Subnet | <pre>map(object({<br>    name                                      = string<br>    address_prefixes                          = string<br>    private_endpoint_network_policies_enabled = bool<br><br>  }))</pre> | n/a | yes |
| <a name="input_keyvault_dns_name"></a> [keyvault\_dns\_name](#input\_keyvault\_dns\_name) | Private DNS Zone Key Vault | `string` | n/a | yes |
| <a name="input_keyvault_monitor"></a> [keyvault\_monitor](#input\_keyvault\_monitor) | Azure Monitor Diagnostic for Key Vault | <pre>map(object({<br>    log_category          = string<br>    log_rention_policy    = bool<br>    metric_category       = string<br>    metric_rention_policy = bool<br>  }))</pre> | n/a | yes |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | Key vault | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group. | `string` | n/a | yes |
| <a name="input_mysql_database"></a> [mysql\_database](#input\_mysql\_database) | Database in MySQL Server | <pre>map(object({<br>    charset   = string<br>    collation = string<br>  }))</pre> | n/a | yes |
| <a name="input_mysql_dns_name"></a> [mysql\_dns\_name](#input\_mysql\_dns\_name) | Private DNS Zone MySQL Server | `string` | n/a | yes |
| <a name="input_mysqlserver_monitor"></a> [mysqlserver\_monitor](#input\_mysqlserver\_monitor) | Azure Monitor Diagnostic MySQL Server | <pre>map(object({<br>    log_category          = string<br>    log_rention_policy    = bool<br>    metric_category       = string<br>    metric_rention_policy = bool<br>  }))</pre> | n/a | yes |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | Object ID | `string` | n/a | yes |
| <a name="input_on_prem_snet"></a> [on\_prem\_snet](#input\_on\_prem\_snet) | On\_Prem Subnet | <pre>map(object({<br>    address_prefixes                          = string<br>    private_endpoint_network_policies_enabled = bool<br><br>  }))</pre> | n/a | yes |
| <a name="input_onprem_instance"></a> [onprem\_instance](#input\_onprem\_instance) | On prem Jumpbox Virtual Machine | <pre>map(object({<br>    vm_size        = string<br>    admin_username = string<br>    #admin_password       = string<br>    caching              = string<br>    storage_account_type = string<br>    publisher            = string<br>    offer                = string<br>    sku                  = string<br>    os_version           = string<br>    instance             = string<br>  }))</pre> | n/a | yes |
| <a name="input_onprem_mysql_server"></a> [onprem\_mysql\_server](#input\_onprem\_mysql\_server) | MySQL Server | <pre>map(object({<br>    admin_login = string<br>    #admin_login_password    = string<br>    sku_name                = string<br>    version                 = string<br>    ssl_enforcement_enabled = bool<br>  }))</pre> | n/a | yes |
| <a name="input_onprem_pip"></a> [onprem\_pip](#input\_onprem\_pip) | Public IP for onprem Jumpbox | <pre>map(object({<br>    allocation_method = string<br>    sku               = string<br>    env               = string<br>  }))</pre> | n/a | yes |
| <a name="input_onprem_vnet_connection"></a> [onprem\_vnet\_connection](#input\_onprem\_vnet\_connection) | Virtual Network Gateways Connection On\_prem to Azure Cloud | <pre>map(object({<br>    name       = string<br>    type       = string<br>    shared_key = string<br>  }))</pre> | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Random password | <pre>map(object({<br>    length           = number<br>    special          = bool<br>    override_special = string<br>  }))</pre> | n/a | yes |
| <a name="input_private_dns_link"></a> [private\_dns\_link](#input\_private\_dns\_link) | The name of the Private DNS Zone Virtual Network Link | `string` | n/a | yes |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | The name of the Private DNS Zone virtual network link | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resource group | <pre>map(object({<br>    instance = string<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to associate with the resource group. | `map(string)` | n/a | yes |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | Virtual Network | <pre>map(object({<br>    instance           = string<br>    vnet_address_space = string<br>  }))</pre> | n/a | yes |
| <a name="input_vnet_gateway"></a> [vnet\_gateway](#input\_vnet\_gateway) | Virtual Network Gateways | <pre>map(object({<br>    gateway_type                  = string<br>    vpn_type                      = string<br>    sku                           = string<br>    private_ip_address_allocation = string<br>  }))</pre> | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload | `string` | n/a | yes |




  
