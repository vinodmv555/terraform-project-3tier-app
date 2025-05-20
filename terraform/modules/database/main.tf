resource "azurerm_mysql_flexible_server" "myapp_db" {
    name = var.server_name
    resource_group_name = var.resource_group_name
    location = var.location
    version = var.mysql_version

    administrator_login = var.admin_username
    administrator_password = var.admin_password

    sku_name = var.sku_name
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup_enabled = var.geo_redundant_backup

    pub
  
}