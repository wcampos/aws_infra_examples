#--------------------------------------------------------------
# General
#--------------------------------------------------------------

variable "environment" {
    type = string
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "ssl-cert-arn" {
    type = string
}

variable "domain" {
    type = string
}

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

variable "vpc_cidr_block" {}

variable "azs" {
    type = list 
}
variable "private_subnets" {
    type = list 
} 
variable "public_subnets" {
    type = list 
}
