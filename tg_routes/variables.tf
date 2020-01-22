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