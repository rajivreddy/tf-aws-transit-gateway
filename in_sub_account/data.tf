data "aws_vpc" "this" {
  cidr_block = var.cidr_block
  state = "available" 
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id

  tags = var.subnet_tags
}