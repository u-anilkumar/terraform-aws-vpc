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

resource "aws_eip" "this" {
    tags = local.eip_final_tags
    depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
    subnet_id = aws_subnet.public[0].id
    allocation_id = aws_eip.this.id
    tags=local.nat_gw_final_tags
    availability_mode = var.availability_mode_natgw
    depends_on = [aws_internet_gateway.this]

} 

resource "aws_route" "public" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.public.id
    gateway_id = aws_internet_gateway.this.id
     
}

resource "aws_route" "private" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.private.id
    nat_gateway_id = aws_nat_gateway.this.id
     
}

resource "aws_route" "database" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.database.id
    nat_gateway_id = aws_nat_gateway.this.id
     
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidr)
    subnet_id = aws_subnet.database[count.index].id
    route_table_id = aws_route_table.database.id
}