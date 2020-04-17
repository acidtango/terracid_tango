variable "domain" {
  description = "The DNS domain name of the site (ex: acidtango.com)"
}

variable "hostname" {
  description = "The hostname to be used for this resource (ex: blog.acidtango.com)"
}

variable "s3_bucket" {
  description = "The AWS S3 bucket config."

  type = object({
    name = string
    tags = object({
      Name    = string
      Env     = string
      Project = string
    })
  })
}

variable "cache_default_ttl" {
  description = "Cloudfront's cache default time to live."
  default     = 3600
}

variable "cache_max_ttl" {
  description = "Cloudfront's cache maximun time to live."
  default     = 86400
}
