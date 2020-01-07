output "tg_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = concat(aws_ec2_transit_gateway.this.*.arn, [""])[0]
}

output "tg_association_default_route_table_id" {
  description = " Identifier of the default association route table"
  value       = concat(aws_ec2_transit_gateway.this.*.association_default_route_table_id, [""])[0]
}

output "tg_id" {
  description = " EC2 Transit Gateway identifier"
  value       = concat(aws_ec2_transit_gateway.this.*.id, [""])[0]
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = concat(aws_ec2_transit_gateway.this.*.owner_id, [""])[0]
}

output "tg_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = concat(aws_ec2_transit_gateway.this.*.propagation_default_route_table_id, [""])[0]
}

####### Customer Gateway  #############

output "cg_id" {
  description = "The amazon-assigned ID of the gateway."
  value       = concat(aws_customer_gateway.this.*.id, [""])[0]
}
output "cg_bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  value       = concat(aws_customer_gateway.this.*.bgp_asn, [""])[0]
}
