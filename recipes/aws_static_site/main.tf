terraform {
  required_version = ">= 0.12.24"
}

# Terraform AWS Provider
# Docs: https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# Cloudfront needs the certificates to be in us-east-1 but it doesn't look it up
# automatically, we need to define another provider and use it in our aws_acm_certificate
# More info: https://github.com/hashicorp/terraform/issues/10957#issuecomment-269653276
provider "aws" {
  region = "us-east-1"
  alias  = "useast1"
}

# Terraform modules for staging and production environments
# Docs: https://www.terraform.io/docs/configuration/modules.html

# module "your_module" {
#   source = "./resources"

#   hostname = "subdomain.${var.domain}"
#   domain = var.domain
#   s3_bucket = {
#     name = "your-bucket-name"
#     tags = {
#       Name    = ""
#       Env     = ""
#       Project = ""
#     }
#   }
# }
