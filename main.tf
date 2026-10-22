resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = local.igw_final_tags
}

