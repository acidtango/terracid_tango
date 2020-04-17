variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "eu-west-1"
}

variable "domain" {
  description = "The DNS domain name of the site (ex: acidtango.com)"
}

