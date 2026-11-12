
# Resource Group
resource "azurerm_resource_group" "security_lab" {
  name     = "rg-terraform-security-lab"
  location = "East Asia"

  tags = {
    Environment = "Lab"
    Project     = "Azure-Secure-Infrastructure"
    ManagedBy   = "Terraform"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "security_vnet" {
  name                = "vnet-terraform-security"
  location            = azurerm_resource_group.security_lab.location
  resource_group_name = azurerm_resource_group.security_lab.name
  address_space       = ["10.20.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "security_subnet" {
  name                            = "snet-terraform-security"
  resource_group_name             = azurerm_resource_group.security_lab.name
  virtual_network_name            = azurerm_virtual_network.security_vnet.name
  address_prefixes                = ["10.20.1.0/24"]
  default_outbound_access_enabled = false
}

# Network Security Group
resource "azurerm_network_security_group" "security_nsg" {
  name                = "nsg-terraform-security"
  location            = azurerm_resource_group.security_lab.location
  resource_group_name = azurerm_resource_group.security_lab.name

  # No custom inbound Allow rules.
  # Azure's default NSG rules remain in effect.
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "security_association" {
  subnet_id                 = azurerm_subnet.security_subnet.id
  network_security_group_id = azurerm_network_security_group.security_nsg.id
}
