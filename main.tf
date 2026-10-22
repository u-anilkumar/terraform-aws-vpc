resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = local.igw_final_tags
}

resource "aws_subnet" "public" {
    
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnet_cidr[count.index]
    map_public_ip_on_launch = true
    tags = merge(
        local.common_tags,
        {
            #roboshop-dev-public-az_name
            Name = "${var.project}-${var.environment}-public-${local.AZ_names[count.index]}"
        },
        var.public_subnet_tags
    availability__zone = local.AZ_names[count.index]
    )
}