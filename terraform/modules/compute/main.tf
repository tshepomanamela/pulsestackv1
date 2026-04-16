resource "azurerm_public_ip" "main" {
    name                = "pulsestack-pip"
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Static"
}
resource "azurerm_network_interface" "main" {
  
    name                = "pulsestack-nic"
    location            = var.location
    resource_group_name = var.resource_group_name
    
    ip_configuration {
        name                          = "internal"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.main.id
    }

    
}
resource "azurerm_linux_virtual_machine" "main" {
    name                = "pulsestack-vm"
    location            = var.location
    resource_group_name = var.resource_group_name
    size                = "Standard_B2s"
    admin_username      = "azureuser"
    network_interface_ids = [
        azurerm_network_interface.main.id,
    ]

    admin_ssh_key {
        username   = "azureuser"
        public_key = var.ssh_public_key
    }
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 30
    }
   source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"

   }
   custom_data = base64encode(file("${path.module}/../../scripts/bootstrap.sh"))
   
}
output "public_ip" {
    value = azurerm_public_ip.main.ip_address
}