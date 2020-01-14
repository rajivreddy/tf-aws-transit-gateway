provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

locals {
  crate_ram_resource_share           = var.create_tg ? 1 : 0
  create_ram_resource_association    = var.create_tg ? 1 : 0
  create_ram_principal_association   = var.allow_external_principals == "true" && length(var.ram_principals) != 0 ? length(var.ram_principals) : 0
  create_tg_vpc_attachment           = var.create_tg && var.vpc_id != "" && length(var.subnet_ids) != 0 ? 1 : 0
  create_transit_gateway_route_table = var.create_tg && var.create_tg_route_table ? 1 : 0
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
  count      = length(var.cgw_ip_address) != 0 ? length(var.cgw_ip_address) : 0
  bgp_asn    = var.cgw_ip_address[count.index]["bgp_asn"]
  ip_address = var.cgw_ip_address[count.index]["ip_address"]
  type       = var.cgw_ip_address[count.index]["type"]
  tags = merge(
    {
      "Name" = format("%s-%s", var.cgw_ip_address[count.index]["name"], "CG")
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
  lifecycle {
    create_before_destroy = true
  }
}

## Principle/Account association

resource "aws_ram_principal_association" "this" {
  count              = local.create_ram_principal_association
  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].id
  lifecycle {
    create_before_destroy = true
  }
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

##### Managing an EC2 Transit Gateway Route Table.

resource "aws_ec2_transit_gateway_route_table" "this" {
  count              = local.create_transit_gateway_route_table
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "tg_rt")
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

# ##### Managing Route in Route table
# resource "aws_ec2_transit_gateway_route" "example" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.example.id}"
#   transit_gateway_route_table_id = "${aws_ec2_transit_gateway.example.association_default_route_table_id}"
# }

resource "aws_vpn_connection" "this" {
  count                 = length(var.cgw_ip_address) != 0 ? length(var.cgw_ip_address) : 0
  customer_gateway_id   = aws_customer_gateway.this[count.index].id
  transit_gateway_id    = aws_ec2_transit_gateway.this[0].id
  vpn_gateway_id        = var.vpn_gateway_id
  type                  = var.cgw_ip_address[count.index]["type"]
  static_routes_only    = var.static_routes_only
  tunnel1_inside_cidr   = var.cgw_ip_address[count.index]["tunnel1_inside_cidr"]
  tunnel2_inside_cidr   = var.cgw_ip_address[count.index]["tunnel2_inside_cidr"]
  tunnel1_preshared_key = var.cgw_ip_address[count.index]["tunnel1_preshared_key"] == "" ? null : var.cgw_ip_address[count.index]["tunnel1_preshared_key"]
  tunnel2_preshared_key = var.cgw_ip_address[count.index]["tunnel2_preshared_key"] == "" ? null : var.cgw_ip_address[count.index]["tunnel2_preshared_key"]
  tags = merge(
    {
      "Name" = format("%s-%s", var.cgw_ip_address[count.index]["name"], "VPN")
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
