provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

resource "aws_ec2_transit_gateway" "example" {
  description = var.description
  dns_support = var.dns_support
  amazon_side_asn = var.amazon_side_asn
  auto_accept_shared_attachments = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  vpn_ecmp_support = var.vpn_ecmp_support
}