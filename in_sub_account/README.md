# Terraform IAC for AWS Transit Gateway Accepter in Dest Account

## Prerequisites

- Terraform 0.12.x
- aws cli

## Input variables

| Name                    | Description                               | Type        |
| ----------------------- | ----------------------------------------- | ----------- |
| shared_credentials_file | Path of AWS creds identifier              | String      |
| profile                 | AWS profile to use create these resources | string      |
| region                  | Region id                                 | string |
|additional_tags | Additional tags for resources  | map(string)|
|name|The ARN of the resource share|string|
|share_arn|The ARN of the resource share|string|
|subnet_ids|Identifiers of EC2 Subnets|string|
|vpc_id|Identifiers of VPC|string|
|transit_gateway_id|Identifier of EC2 Transit Gateway|string|
|dns_support|Whether DNS support is enabled. Valid values: disable, enable|string|
|ipv6_support|||
|transit_gateway_default_route_table_association|Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table.|bool|
|transit_gateway_default_route_table_propagation|Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways|bool|

Link: https://www.terraform.io/docs/configuration/variables.html

### Use as Standalone TF template

```bash
cp input.tfvars.example input.tfvars
terraform init
terraform plan -var-file=./input.tfvars
terraform apply -var-file=./input.tfvars
```

### Output variables

| Name                                  | Description                                                                                |
| ------------------------------------- | ------------------------------------------------------------------------------------------ |
|invitation_arn|The ARN of the resource share invitation|
|share_id|The ID of the resource share as displayed in the console.|
|status|The status of the invitation (e.g., ACCEPTED, REJECTED).|
|||
|||
|||
|||
|||
|||
|||