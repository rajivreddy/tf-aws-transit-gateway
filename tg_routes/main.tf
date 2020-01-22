provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

##### Managing an EC2 Transit Gateway Route Table.

resource "aws_ec2_transit_gateway_route_table" "this" {
  count              = var.create_rt && length() ? length() : 0
  transit_gateway_id = var.transit_gateway_id
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
