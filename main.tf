################################################################################
# Root Module - Azure VM + Load Balancer
# Standard: Enterprise-grade, modular, least-privilege
################################################################################
locals {
  common_tags = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.tags
  )
}

################################################################################
# Resource Group
################################################################################

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name.name
  location = var.location
  tags     = local.common_tags
}

################################################################################
# Networking Module
################################################################################

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project             = var.project
  vnet_address_space  = var.vnet_address_space
  subnet_prefixes     = var.subnet_prefixes
  tags                = local.common_tags
}

################################################################################
# Security Module (NSG + Key Vault)
################################################################################

module "security" {
  source = "./modules/security"

  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  environment          = var.environment
  project              = var.project
  vm_subnet_id         = module.networking.vm_subnet_id
  allowed_source_cidrs = var.allowed_source_cidrs
  tenant_id            = var.tenant_id
  tags                 = local.common_tags

  depends_on = [module.networking]
}

################################################################################
# Load Balancer Module
################################################################################

module "loadbalancer" {
  source = "./modules/loadbalancer"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project             = var.project
  lb_sku              = var.lb_sku
  lb_frontend_port    = var.lb_frontend_port
  lb_backend_port     = var.lb_backend_port
  lb_protocol         = var.lb_protocol
  health_probe_port   = var.health_probe_port
  health_probe_proto  = var.health_probe_proto
  tags                = local.common_tags
}

################################################################################
# Virtual Machine Module (x5)
################################################################################

module "vms" {
  source = "./modules/vm"

  for_each = { for idx in range(var.vm_count) : format("%02d", idx + 1) => idx }

  vm_name             = "${local.vm_name_prefix}-${each.key}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project             = var.project
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  vm_subnet_id        = module.networking.vm_subnet_id
  lb_backend_pool_id  = module.loadbalancer.backend_pool_id
  key_vault_id        = module.security.key_vault_id
  os_disk_type        = var.os_disk_type
  os_disk_size_gb     = var.os_disk_size_gb
  source_image        = var.source_image
  availability_zone   = tostring((each.value % 3) + 1)   # Spread across 3 AZs
  enable_boot_diag    = var.enable_boot_diag
  storage_account_uri = var.enable_boot_diag ? module.networking.diag_storage_uri : null
  tags                = merge(local.common_tags, { "vm-index" = each.key })

  depends_on = [module.security, module.loadbalancer, module.networking]
}
