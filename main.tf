provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

locals {
  bgp_asn = var.default_routing == "static" ? 65000 : var.bgp_asn
}

resource "aws_ec2_transit_gateway" "this" {
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
