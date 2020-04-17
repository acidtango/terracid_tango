data "aws_availability_zones" "available" {
}

variable "site_name" {
  description = "The DNS domain name of the site"
}

variable "aws_credentials_file" {
  type        = string
  description = "Location of the AWS credentials file"
}

variable "aws_cli_profile" {
  type        = string
  description = "AWS profile to use"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

variable "aws_key_name" {
  type        = string
  description = "Desired name of AWS key pair"
}

# RancherOS 1.5.3 (x64)
# https://rancher.com/docs/os/v1.x/en/installation/amazon-ecs/
variable "rancher_amis" {
  default = {
    ap-northeast-1 = "ami-0a7a9e44ec4c01f7e"
    ap-northeast-2 = "ami-08bba0cd9934cef90"
    ap-south-1     = "ami-097e19198e915f12c"
    ap-southeast-1 = "ami-085ce6d3cf455dba0"
    ap-southeast-2 = "ami-004dc02c07766a9a6"
    ca-central-1   = "ami-0bde65d7509878a90"
    cn-north-1     = "ami-0dfbc6d88d4048e24"
    cn-northwest-1 = "ami-04d3267529863091d"
    eu-central-1   = "ami-0fa23b013188bf809"
    eu-north-1     = "ami-02042aefd9a6743c0"
    eu-west-1      = "ami-08f19c0126135b103"
    eu-west-2      = "ami-081d1809e05a29ff9"
    eu-west-3      = "ami-0622559381120fe22"
    sa-east-1      = "ami-0ad4e6bd39fe14dfa"
    us-east-1      = "ami-0395c86bff9bc1bce"
    us-east-2      = "ami-02027918438bc6897"
    us-west-1      = "ami-03e54b15c63b99c47"
    us-west-2      = "ami-0a7f51b27f45e8d77"
  }
}

# Debian Linux 9 Stretch (2019-08-06)
# https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch
variable "debian_amis" {
  default = {
    ap-northeast-1 = "ami-03a7c9b843a80ddae"
    ap-northeast-2 = "ami-044894c007c083b3b"
    ap-south-1     = "ami-0452fd58a3af17b46"
    ap-southeast-1 = "ami-0a87b24193b908e35"
    ap-southeast-2 = "ami-0c0c6cbac37868da3"
    ca-central-1   = "ami-072a14ca57c3f0c76"
    eu-central-1   = "ami-03b32b30556b952dc"
    eu-north-1     = "ami-02d9a375d51f80e38"
    eu-west-1      = "ami-01e859cab43214736"
    eu-west-2      = "ami-090ae77c43ce5a899"
    eu-west-3      = "ami-09b39395e7d977746"
    sa-east-1      = "ami-0a547439a0c93bd44"
    us-east-1      = "ami-0f5c5066b40f2414e"
    us-east-2      = "ami-023fd0a6ecb9a9d88"
    us-west-1      = "ami-0a26bc1da36c00496"
    us-west-2      = "ami-0d53560207135219b"
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

