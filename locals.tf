locals{
    common_tags = {
    Terraform = true
    Environment = var.environment
    Project = var.project
    }

    vpc_final_tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        },
        var.vpc_tags
    )

    igw_final_tags= merge(
        local.common_tags,
        { 
            Name = "${var.project}-${var.environment}" 
        },
        var.igw_tags
    )
    AZ_names = slice(data.aws_availability_zones.available.names, 0, 2)

    rt_public_tags = merge(
        local.common_tags,
        {
            #roboshop-dev-public
            Name = "${var.project}-${var.environment}-public"
        },
        var.public_route_table_tags
    )

    rt_private_tags = merge(
        local.common_tags,
        {
            
            Name = "${var.project}-${var.environment}-private"
        },
        var.private_route_table_tags
    
    )

    rt_database_tags = merge( 
        local.common_tags,
        {
            #roboshop-dev-public
            Name = "${var.project}-${var.environment}-database"
        },
        var.database_route_table_tags
    )
    
   eip_final_tags = merge( 
        local.common_tags,
        {
            #roboshop-dev-public
            Name = "${var.project}-${var.environment}-NAT"
        },
        var.eip_tags
    )

    nat_gw_final_tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        },
        var.nat_tags
    )
}