# Copy this file to terraform.tfvars and fill in your values
# NEVER commit terraform.tfvars to source control — add it to .gitignore

resource_group_name   = "rg-windows-vm"
location              = "SouthIndia"
vm_name               = "vm-windows-01"
vm_size               = "Standard_D2s_v3"
admin_username        = "azureadmin"
admin_password        = "Evolym@123456"   # min 12 chars, upper+lower+digit+special
os_disk_size_gb       = 128
os_disk_type          = "Premium_LRS"
vnet_address_space    = ["10.0.0.0/16"]
subnet_address_prefix = ["10.0.1.0/24"]
environment           = "dev"

tags = {
  project    = "my-project"
  owner      = "Munish Tyagi"
  cost_center = "12345"
}
