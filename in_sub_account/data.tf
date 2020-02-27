data "aws_vpc" "this" {
  count = var.cidr_block != "" && var.vpc_id == "" ? 1 :0 
  cidr_block = var.cidr_block
  state = "available" 
}

data "aws_subnet_ids" "this" {
  count = length(var.subnet_tags) >0 && length(var.subnet_ids) == 0 ? 1 :0 
  vpc_id = data.aws_vpc.this[0].id

  tags = var.subnet_tags
}

data "aws_ram_resource_share" "this" {
  name = var.ram_name
  resource_owner = var.resource_owner
  filter {
    name   = "Name"
    values = [var.ram_tag]
  }
}


data "aws_ec2_transit_gateway" "this" {
  provider = aws.source
 count = length(var.transit_gateway_tags) >0 && var.transit_gateway_id == "" ? 1 :0 
  tags = var.transit_gateway_tags
}

output "transit_gateway_id" {
  description = "description"
  value       = data.aws_ec2_transit_gateway.this[0].id
}
data "aws_ec2_transit_gateway_route_table" "ss_rt" {
 provider = aws.source
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.this[0].id]
  }
  dynamic "filter" {
    iterator = tags
    for_each = var.ss_rt_tags
    content {
      name   = "tag:${tags.key}"
      values = [tags.value]
    }
  }
}

data "aws_ec2_transit_gateway_route_table" "dest_rt" {
 provider = aws.source
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.this[0].id]
  }
  dynamic "filter" {
    iterator = tags
    for_each = var.dest_rt_tags
    content {
      name   = "tag:${tags.key}"
      values = [tags.value]
    }
  }
}

output "ss_rt_id" {
  description = "description"
  value       = data.aws_ec2_transit_gateway_route_table.ss_rt.id
}

output "dest_rt_id" {
  description = "description"
  value       = data.aws_ec2_transit_gateway_route_table.dest_rt.id
}