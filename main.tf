provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

locals {
  bgp_asn                          = var.default_routing == "static" ? 65000 : var.bgp_asn
  crate_ram_resource_share         = var.create_tg ? 1 : 0
  create_ram_resource_association  = var.create_tg ? 1 : 0
  create_ram_principal_association = var.allow_external_principals == "true" && length(var.ram_principals) != 0 ? length(var.ram_principals) : 0
  create_tg_vpc_attachment         = var.create_tg && var.vpc_id != "" && length(var.subnet_ids) != 0 ? 1 : 0
}

resource "aws_ec2_transit_gateway" "this" {
  count                           = var.create_tg ? 1 : 0
  description                     = var.description
  dns_support                     = var.dns_support
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  vpn_ecmp_support                = var.vpn_ecmp_support
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "TG")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}

# Create customer Gateway for IPSec VPN tunnel
resource "aws_customer_gateway" "this" {
  count      = var.create_cg ? 1 : 0
  bgp_asn    = local.bgp_asn
  ip_address = var.ip_address
  type       = var.type
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "CG")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}
#### Manages a Resource Access Manager (RAM) Resource Share ###

resource "aws_ram_resource_share" "this" {
  count                     = local.crate_ram_resource_share
  name                      = var.name
  allow_external_principals = var.allow_external_principals
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "RAM")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}

### Resource association
resource "aws_ram_resource_association" "this" {
  count              = local.create_ram_resource_association
  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

## Principle/Account association

resource "aws_ram_principal_association" "this" {
  count              = local.create_ram_principal_association
  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].id
}

######## Create the TG VPC attachment in the Shared Service account...
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count                                           = local.create_tg_vpc_attachment
  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = aws_ec2_transit_gateway.this[0].id
  vpc_id                                          = var.vpc_id
  dns_support                                     = var.dns_support
  ipv6_support                                    = var.ipv6_support
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "VPC_Attach")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}
