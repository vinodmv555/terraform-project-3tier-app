locals {
  rg_name   = "rg-myapp-${var.environment}-${var.location}"
  nsg_ports = [22, 80, 443]

  common_tags = {
    env        = var.environment
    created_by = "terraform"
    app_name   = "myapp"
  }
}