data "aws_ec2_transit_gateway_route_table" "ss_rt" {

  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.this[0].id]
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

output "ss_rt_id" {
  description = "description"
  value       = data.aws_ec2_transit_gateway_route_table.ss_rt.id
}
