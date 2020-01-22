provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

##### Managing an EC2 Transit Gateway Route Table.

resource "aws_ec2_transit_gateway_route_table" "this" {
  count              = var.create_rt && length(var.tg_route_table_names) > 0 ? length(var.tg_route_table_names) : 0
  transit_gateway_id = var.transit_gateway_id
  tags = merge(
    {
      "Name" = format("%s-%s", var.tg_route_table_names[count.index]["name"], "tg_rt")
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

### Route table association
#### Route tables Association for VPN Attachments
# resource "aws_ec2_transit_gateway_route_table_association" "vpn" {
#   count = length(aws_vpn_connection.this.*.id)
#   transit_gateway_attachment_id  = aws_vpn_connection.this[count.index].transit_gateway_attachment_id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
# }
