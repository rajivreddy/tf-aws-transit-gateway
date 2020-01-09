# Terraform IAC for AWS Transit Gateway

## Prerequisites

- Terraform 0.12.x
- aws cli

## Input variables

| Name                                            | Description                                                                                                                                                                      | Type              |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| shared_credentials_file                         | Path of AWS creds identifier                                                                                                                                                     | String            |
| profile                                         | AWS profile to use create these resources                                                                                                                                        | string            |
| region                                          | Region id                                                                                                                                                                        | map(string)       |
| vpc_id                                          | VPC id for existing vpc to create subnets                                                                                                                                        | string            |
| additional_tags                                 |                                                                                                                                                                                  | map(string)       |
| create_tg                                       | Want to create Transit Gateway                                                                                                                                                   | bool              |
| description                                     | Description of the EC2 Transit Gateway                                                                                                                                           | string            |
| dns_support                                     | Whether DNS support is enabled. Valid values: disable, enable                                                                                                                    | string            |
| amazon_side_asn                                 | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534                                                                         | number            |
| auto_accept_shared_attachments                  | Whether resource attachment requests are automatically accepted. Valid values: disable, enable                                                                                   | string            |
| default_route_table_association                 | Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable                                                | string            |
| default_route_table_propagation                 | Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable                                                | string            |
| vpn_ecmp_support                                | Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable                                                                                      | string            |
| cgw_ip_address                                  | he IP address of the gateway's Internet-routable external interface.                                                                                                             | list(map(string)) |
| allow_external_principals                       | Indicates whether principals outside your organization can be associated with a resource share                                                                                   | string            |
| ram_principals                                  | The principal to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN. | list              |
| subnet_ids                                      | Identifiers of EC2 Subnets                                                                                                                                                       | list              |
| vpc_id                                          | Identifiers of EC2 Subnets.                                                                                                                                                      | string            |
| ipv6_support                                    | Whether IPv6 support is enabled. Valid values: disable, enable. Default value: disable                                                                                           | string            |
| transit_gateway_default_route_table_association | Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table.                                                            | string            |
| transit_gateway_default_route_table_propagation | Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table                                                          | string            |
| create_tg_route_table                           | Do you want to create an Route table for TG                                                                                                                                      | bool              |

Link: https://www.terraform.io/docs/configuration/variables.html

### Use as Standalone TF template

```bash
cp input.tfvars.example input.tfvars
terraform init
terraform plan -var-file=./input.tfvars
terraform apply -var-file=./input.tfvars
```

### Output variables

| Name                | Description                    |
| ------------------- | ------------------------------ |
| tg_arn              | EC2 Transit Gateway Amazon Resource Name ARN |
| tg_association_default_route_table_id   | Identifier of the default association route table         |
| tg_id | EC2 Transit Gateway identifier  |
