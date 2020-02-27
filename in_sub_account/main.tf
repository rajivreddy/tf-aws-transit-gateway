locals {
  create_tg_vpc_attachment = var.cidr_block != "" && length(var.subnet_tags) != 0 ? 1 : 0
}

######### Accept shared resources in RAM

resource "aws_ram_resource_share_accepter" "this" {
  share_arn = var.share_arn
}

######## Create the VPC attachment in the Dest account...
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count                                           = local.create_tg_vpc_attachment
  subnet_ids                                      = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnet_ids.this[0].ids
  transit_gateway_id                              = var.transit_gateway_id != "" ? var.transit_gateway_id : data.aws_ec2_transit_gateway.this[0].id
  vpc_id                                          = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.this[0].id
  dns_support                                     = var.dns_support
  ipv6_support                                    = var.ipv6_support
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, "vpc-attachment")
    },
    var.additional_tags
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [aws_ram_resource_share_accepter.this]
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc" {
  provider = aws.source
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.dest_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpc" {
  provider = aws.source
  transit_gateway_attachment_id  =  aws_ec2_transit_gateway_vpc_attachment.this[0].id
  transit_gateway_route_table_id =  data.aws_ec2_transit_gateway_route_table.ss_rt.id
}