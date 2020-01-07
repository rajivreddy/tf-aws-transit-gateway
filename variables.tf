variable "shared_credentials_file" {
  type    = string
  default = "/Users/username/.aws/credentials"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "additional_tags" {
  type = map(string)
  default = {
    "createdby" = "devops"
  }
}

######### Transit Gateway #########
variable "create_tg" {
  type        = bool
  description = "Want to create Transit Gateway"
  default     = true
}

variable "name" {
  type        = string
  description = "Name of the EC2 Transit Gateway"
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the EC2 Transit Gateway"
  default     = null
}

variable "dns_support" {
  type        = string
  description = "Whether DNS support is enabled. Valid values: disable, enable"
  default     = "enable"
}

variable "amazon_side_asn" {
  type        = number
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534"
  default     = "64512"
}
variable "auto_accept_shared_attachments" {
  type        = string
  description = "Whether resource attachment requests are automatically accepted. Valid values: disable, enable"
  default     = "enable"
}
variable "default_route_table_association" {
  type        = string
  description = "Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable"
  default     = "enable"
}
variable "default_route_table_propagation" {
  type        = string
  description = "Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable"
  default     = "enable"
}

variable "vpn_ecmp_support" {
  type        = string
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable"
  default     = "enable"
}


######### For Customer Gateway
variable "create_cg" {
  type        = bool
  description = "Want to create Customer Gateway"
  default     = true
}

variable "default_routing" {
  type        = string
  description = "default Routing type allowed values static or dynamic"
  default     = "static"
}

variable "bgp_asn" {
  type        = number
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  default     = null
}

variable "ip_address" {
  type        = string
  description = "The IP address of the gateway's Internet-routable external interface."
}

variable "type" {
  type        = string
  description = "The type of customer gateway. The only type AWS supports at this time is ipsec.1."
  default     = "ipsec.1"
}


##### For RAM ###

variable "allow_external_principals" {
  type        = string
  description = "Indicates whether principals outside your organization can be associated with a resource share"
  default     = "true"
}

variable "ram_principals" {
  type        = list(string)
  description = "The principal to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  default     = []
}
########## VPC attachments #############

variable "subnet_ids" {
  type = list(string)
  description = "Identifiers of EC2 Subnets."
  default = []
}

variable "vpc_id" {
  type = string
  description = "Identifiers of EC2 Subnets."
  default = ""
}
variable "ipv6_support" {
  type = string
  description = "Whether IPv6 support is enabled. Valid values: disable, enable. Default value: disable."
  default = "disable"
}

variable "transit_gateway_default_route_table_association" {
  type = bool
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. "
  default = true
}
variable "transit_gateway_default_route_table_propagation" {
  type = bool
  description = "Identifiers of EC2 Subnets."
  default = true
}
