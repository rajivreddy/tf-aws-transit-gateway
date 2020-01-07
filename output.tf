output "tg_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name ARN"
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

## Customer Gateway

output "cg_id" {
  description = "The amazon-assigned ID of the gateway."
  value       = concat(aws_customer_gateway.this.*.id, [""])[0]
}
output "cg_bgp_asn" {
  description = "The gateway's Border Gateway Protocol BGP Autonomous System Number (ASN)."
  value       = concat(aws_customer_gateway.this.*.bgp_asn, [""])[0]
}

## Resource Access Manager (RAM) Resource Share
output "ram_resource_share_arn" {
  description = "The Amazon Resource Name ARN of the resource share."
  value       = concat(aws_ram_resource_share.this.*.arn, [""])[0]
}

output "ram_resource_share_id" {
  description = "The Amazon Resource Name ARN of the resource share"
  value       = concat(aws_ram_resource_share.this.*.id, [""])[0]
}
## Resource association

output "ram_resource_associatiom_id" {
  description = "The Amazon Resource Name ARN of the resource share"
  value       = concat(aws_ram_resource_association.this.*.id, [""])[0]
}
## Principle/Account association
output "output" {
  description = "The Amazon Resource Name ARN of the Resource Share and the principal, separated by a comma."
  value       = aws_ram_principal_association.this.*.id
}
## TG VPC attachment in the Shared Service account
output "transit_gateway_vpc_attachment_id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = concat(aws_ec2_transit_gateway_vpc_attachment.this.*.id, [""])[0]
}
