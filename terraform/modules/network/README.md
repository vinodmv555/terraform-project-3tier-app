# Sample subnet input 
{
  "app-subnet" = { name = "app-subnet", address_prefix = "10.0.1.0/24" },
  "db-subnet"  = { name = "db-subnet",  address_prefix = "10.0.2.0/24" }
}

for_each = { for subnet in var.subnets : subnet.name => subnet } 