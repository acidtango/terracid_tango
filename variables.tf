data "aws_availability_zones" "available" {}

data "aws_acm_certificate" "default" {
  domain      = "${var.site_name}"
  most_recent = true
}

variable "site_name" {
  description = "The DNS domain name of the site"
}

variable "aws_credentials_file" {
  type        = "string"
  description = "Location of the AWS credentials file"
}

variable "aws_cli_profile" {
  type        = "string"
  description = "AWS profile to use"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

variable "aws_key_name" {
  type        = "string"
  description = "Desired name of AWS key pair"
}

# RancherOS 1.5.0 (x64)
variable "rancher_amis" {
  default = {
    ap-northeast-1 = "ami-09a1651831e76846a"
    ap-northeast-2 = "ami-04c7c603a5586aafe"
    ap-south-1     = "ami-0bcc62f1ebf353a70"
    ap-southeast-1 = "ami-0443782221e818bd8"
    ap-southeast-2 = "ami-031c628be26b5921f"
    ca-central-1   = "ami-06a0d5077db5cb530"
    eu-central-1   = "ami-062a6985def70a2ca"
    eu-west-1      = "ami-00cd01b4ce6796af1"
    eu-west-2      = "ami-074223bf7b0ca9f7a"
    eu-west-3      = "ami-068d367d19530a393"
    sa-east-1      = "ami-02703c46a20f47722"
    us-east-1      = "ami-05342ca821afde9d7"
    us-east-2      = "ami-0be73aeb7d3076a36"
    us-west-1      = "ami-0052c7f3c5277f6b7"
    us-west-2      = "ami-0b3a7af468ef99912"
  }
}

# TODO: This AMIs are not valid
# CentOS Linux 7
variable "centos_amis" {
  default = {
    ap-northeast-1 = "ami-25bd2743"
    ap-northeast-2 = "ami-7248e81c"
    ap-south-1     = "ami-5d99ce32"
    ap-southeast-1 = "ami-d2fa88ae"
    ap-southeast-2 = "ami-b6bb47d4"
    ca-central-1   = "ami-dcad28b8"
    eu-central-1   = "ami-337be65c"
    eu-west-1      = "ami-0ff760d16d9497662"
    eu-west-2      = "ami-ee6a718a"
    eu-west-3      = "ami-bfff49c2"
    sa-east-1      = "ami-f9adef95"
    us-east-1      = "ami-4bf3d731"
    us-east-2      = "ami-e1496384"
    us-west-1      = "ami-65e0e305"
    us-west-2      = "ami-a042f4d8"
  }
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR for the Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for the Public Subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR for the Private Subnet 1"
  default     = "10.0.101.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for the Private Subnet 2"
  default     = "10.0.102.0/24"
}
