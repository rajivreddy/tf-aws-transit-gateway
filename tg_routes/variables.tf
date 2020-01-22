variable "shared_credentials_file" {
  type        = string
  description = "Path of AWS creds"
  default     = "/Users/username/.aws/credentials"
}

variable "profile" {
  type        = string
  description = "AWS profile to use create these resources"
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


######### For Route tables #######
variable "create_rt" {
    type = bool
  description = "You want to create Route tables"
  default     = true
}

variable "tg_route_table_names" {
    type = list(map(string))
  description = "description"
  default     = []
}

variable "transit_gateway_id" {
    type = string
  description = "Identifier of EC2 Transit Gateway."
  default     = null
}
