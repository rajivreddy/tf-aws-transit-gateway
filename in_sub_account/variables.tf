variable "shared_credentials_file" {
  type    = string
  default = "/Users/username/.aws/credentials"
}

variable "profile" {
  type    = string
  default = "default"
}
variable "source_profile" {
  type    = string
  description = "description"
  default     = "default"
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
variable "vpc_id" {
  type = string
  description = "VPC id of resource"
  default     = ""
}

variable "subnet_ids" {
  type = list
  description = "VPC id of resource"
  default     = []
}

variable "subnet_tags" {
  type        = map
  description = "Subnet Tags of Subnets."
  default     = {
    "Tier" = "worker_nodes"
    }
}

variable "cidr_block" {
  type = string
  description = "CIDR block of VPC"
  default     = ""
}
variable "transit_gateway_tags" {
  type        = map
  description = "transit_gateway Tags"
  default     = {
    "Tier" = "worker_nodes"
    }
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
  default     = false
}
variable "transit_gateway_default_route_table_propagation" {
  type        = bool
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways"
  default     = false
}
####### 

variable "ss_rt_tags" {
  type = map
  description = "Tags used for creating SS route tables "
  default     = {
    
  }
}

variable "dest_rt_tags" {
  type = map
  description = "Tags used for creating Dest route tables "
  default     = {
    
  }
}
