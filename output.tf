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
  value       = aws_customer_gateway.this.*.id
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
output "ram_principal_association" {
  description = "The Amazon Resource Name ARN of the Resource Share and the principal, separated by a comma."
  value       = aws_ram_principal_association.this.*.id
}
## TG VPC attachment in the Shared Service account
output "transit_gateway_vpc_attachment_id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = concat(aws_ec2_transit_gateway_vpc_attachment.this.*.id, [""])[0]
}
output "vpn_id" {
  description = "The amazon-assigned ID of the VPN connection"
  value       = aws_vpn_connection.this.*.id
}
output "tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = aws_vpn_connection.this.*.tunnel1_address
}
output "tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)."
  value       = aws_vpn_connection.this.*.tunnel1_cgw_inside_address
}
output "tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)."
  value       = aws_vpn_connection.this.*.tunnel1_vgw_inside_address
}
output "tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel"
  value       = aws_vpn_connection.this.*.tunnel1_preshared_key
}
output "tunnel1_bgp_asn" {
  description = "The bgp asn number of the first VPN tunnel"
  value       = aws_vpn_connection.this.*.tunnel1_bgp_asn
}

output "tunnel1_bgp_holdtime" {
  description = "The bgp holdtime of the first VPN tunnel."
  value       = aws_vpn_connection.this.*.tunnel1_bgp_holdtime
}

output "tunnel2_address" {
  description = "The public IP address of the second VPN tunnel."
  value       = aws_vpn_connection.this.*.tunnel2_address
}
output "tunnel2_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (Customer Gateway Side)."
  value       = aws_vpn_connection.this.*.tunnel2_cgw_inside_address
}

output "tunnel2_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (VPN Gateway Side)."
  value       = aws_vpn_connection.this.*.tunnel2_vgw_inside_address
}
output "tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel."
  value       = aws_vpn_connection.this.*.tunnel2_preshared_key
}
output "tunnel2_bgp_asn" {
  description = "The bgp asn number of the second VPN tunnel."
  value       = aws_vpn_connection.this.*.tunnel2_bgp_asn
}
output "tunnel2_bgp_holdtime" {
  description = "The bgp holdtime of the second VPN tunnel."
  value       = aws_vpn_connection.this.*.tunnel2_bgp_holdtime
}
