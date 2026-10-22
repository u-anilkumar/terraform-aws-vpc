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
    
    )
    availability_zone = local.AZ_names[count.index]
}

resource "aws_subnet" "private" {
    
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnet_cidr[count.index]
    tags = merge(
        local.common_tags,
        {
            #roboshop-dev-public-az_name
            Name = "${var.project}-${var.environment}-private-${local.AZ_names[count.index]}"
        },
        var.private_subnet_tags
    
    )
    availability_zone = local.AZ_names[count.index]
}

resource "aws_subnet" "database" {
    
    count = length(var.database_subnet_cidr)
    vpc_id = aws_vpc.this.id
    cidr_block = var.database_subnet_cidr[count.index]
    tags = merge(
        local.common_tags,
        {
            #roboshop-dev-public-az_name
            Name = "${var.project}-${var.environment}-database-${local.AZ_names[count.index]}"
        },
        var.database_subnet_tags
    
    )
    availability_zone = local.AZ_names[count.index]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = local.rt_public_tags
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id
    tags = local.rt_private_tags
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.this.id
    tags = local.rt_database_tags
}