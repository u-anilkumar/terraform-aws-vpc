variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_tags" {
    type = map
}

variable "vpc_cidr"{
    type = string
    default = "10.0.0.0/16"
}