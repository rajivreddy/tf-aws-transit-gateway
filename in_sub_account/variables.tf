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
variable "name" {
  type        = string
  description = "The ARN of the resource share"
  default     = null
}

### RAM ARN
variable "share_arn" {
  type        = string
  description = "The ARN of the resource share"
  default     = null
}

########## VPC attachments #############

variable "subnet_ids" {
  type        = list(string)
  description = "Identifiers of EC2 Subnets."
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "Identifiers of EC2 Subnets."
  default     = ""
}
variable "transit_gateway_id" {
  type        = string
  description = "Identifier of EC2 Transit Gateway."
  default     = ""
}
variable "dns_support" {
  type        = string
  description = "Whether DNS support is enabled. Valid values: disable, enable"
  default     = "enable"
}


variable "ipv6_support" {
  type        = string
  description = "Whether IPv6 support is enabled. Valid values: disable, enable. Default value: disable."
  default     = "disable"
}

variable "transit_gateway_default_route_table_association" {
  type        = bool
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. "
  default     = true
}
variable "transit_gateway_default_route_table_propagation" {
  type        = bool
  description = "Identifiers of EC2 Subnets."
  default     = true
}
