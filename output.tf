output "arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = aws_ec2_transit_gateway.this.arn
}

output "association_default_route_table_id" {
  description = " Identifier of the default association route table"
  value       = aws_ec2_transit_gateway.this.association_default_route_table_id
}

output "id" {
  description = " EC2 Transit Gateway identifier"
  value       = aws_ec2_transit_gateway.this.id
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = aws_ec2_transit_gateway.this.owner_id
}

output "propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = aws_ec2_transit_gateway.this.propagation_default_route_table_id
}
