resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    tags = local.vpc_final_tags
}
    