resource "aws_acm_certificate" "default" {
  provider    = aws.certificate
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"
}

data "aws_route53_zone" "primary" {
  provider = aws.main
  name     = var.domain
}

resource "aws_route53_record" "site" {
  provider = aws.main
  zone_id  = data.aws_route53_zone.primary.zone_id
  name     = var.hostname
  type     = "A"

  alias {
    name = aws_cloudfront_distribution.site.domain_name
    # For CloudFront the zone_id is always the same
    # More info: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# If you have imported a certificate you can add a
# data source and use it instead, remember to change the certificate
# configuration in the cloudfront file too

# data "aws_acm_certificate" "default" {
#   provider    = aws.certificate
#   domain      = "*.${var.domain}"
#   most_recent = true
#   statuses    = ["ISSUED"]
# }