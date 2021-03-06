locals {
  crate_ram_resource_share           = var.create_tg && var.allow_external_principals ? 1 : 0
  create_ram_resource_association    = var.create_tg && var.allow_external_principals ? 1 : 0
  create_ram_principal_association   = var.allow_external_principals == "true" && length(var.ram_principals) != 0 ? length(var.ram_principals) : 0
  create_tg_vpc_attachment           = var.create_tg && var.vpc_id != "" && length(var.subnet_ids) != 0 ? 1 : 0
  all_transit_gateway_vpc_attachment_ids = length(var.transit_gateway_vpc_attachment_ids) > 0 && local.create_tg_vpc_attachment > 0 ? concat(var.transit_gateway_vpc_attachment_ids,aws_ec2_transit_gateway_vpc_attachment.this.*.id): aws_ec2_transit_gateway_vpc_attachment.this.*.id
}
#### Create Transit Gateway
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
      "Name" = format("%s-%s", var.name, "tg")
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

# Create Customer Gateways for IPSec VPN tunnels
resource "aws_customer_gateway" "this" {
  count      = length(var.cgw_ip_address) > 0 ? length(var.cgw_ip_address) : 0
  bgp_asn    = var.cgw_ip_address[count.index]["bgp_asn"]
  ip_address = var.cgw_ip_address[count.index]["ip_address"]
  type       = var.cgw_ip_address[count.index]["type"]
  tags = merge(
    {
      "Name" = format("%s-%s", var.cgw_ip_address[count.index]["name"], "cg")
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
#### Manages a Resource Access Manager (RAM) Resource Share

resource "aws_ram_resource_share" "this" {
  count                     = local.crate_ram_resource_share
  name                      = var.name
  allow_external_principals = var.allow_external_principals
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "ram")
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
  depends_on = [aws_ec2_transit_gateway.this]
}

## Principle/Account association

resource "aws_ram_principal_association" "this" {
  count              = local.create_ram_principal_association
  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_ec2_transit_gateway.this,aws_ram_resource_association.this]
}

######## Create the TG VPC attachment with in Same account account...
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
      "Name" = format("%s-%s-shared-service", var.name, "vpc-attachment")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
  depends_on = []
}

resource "aws_vpn_connection" "this" {
  count                 = length(var.cgw_ip_address) > 0 ? length(var.cgw_ip_address) : 0
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
      "Name" = format("%s-%s", var.cgw_ip_address[count.index]["name"], "vpn")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [aws_customer_gateway.this]
}

##### Create Route table for VPN to VPC 

resource "aws_ec2_transit_gateway_route_table" "this" {
  count              = var.create_tg_route_table ? 1 : 0
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  tags = merge(
    {
      "Name" = format("%s", "vpn_route_table")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [aws_ec2_transit_gateway.this]
}

### Route tables Association for VPN Attachments
resource "aws_ec2_transit_gateway_route_table_association" "vpn" {
  count = length(aws_vpn_connection.this.*.id)
  transit_gateway_attachment_id  = aws_vpn_connection.this[count.index].transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
  depends_on = [aws_vpn_connection.this]
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpc" {
  count = length(local.all_transit_gateway_vpc_attachment_ids)
  transit_gateway_attachment_id  =  local.all_transit_gateway_vpc_attachment_ids[count.index]
  transit_gateway_route_table_id =  aws_ec2_transit_gateway_route_table.this[0].id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
################## Additional Route tables

resource "aws_ec2_transit_gateway_route_table" "additional_rts" {
  for_each = var.additional_rts
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  tags = merge(
    {
      "Name" = format("%s", each.key)
    },
    each.value
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}

########## Associate VPC accachment to Route table

resource "aws_ec2_transit_gateway_route_table_association" "vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.ss_rt.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
