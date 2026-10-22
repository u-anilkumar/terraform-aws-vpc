locals{
    common_tags{
    Terraform = true
    Environment = var.environment
    Project = var.project
    }

    vpc_final_tags = merge(
        local.common_tags,
        Name = "${var.project}-${var.environment}",
        var.vpc_tags
    )
    
}