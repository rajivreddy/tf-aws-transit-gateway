locals {
   create_tg_vpc_attachment         = var.transit_gateway_id != "" && var.vpc_id != "" && length(var.subnet_ids) != 0 ? 1 : 0
}

######### Accept shared resources in RAM

resource "aws_ram_resource_share_accepter" "this" {
  share_arn = var.share_arn
}

######## Create the VPC attachment in the Dest account...
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count                                           = local.create_tg_vpc_attachment
  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = var.transit_gateway_id
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
