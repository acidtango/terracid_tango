resource "aws_acm_certificate" "default" {
  domain_name       = var.site_name
  validation_method = "DNS"
}

data "aws_route53_zone" "selected" {
  name         = var.site_name
}

resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = "${aws_lb.public_lb.dns_name}"
    zone_id                = "${aws_lb.public_lb.zone_id}"
    evaluate_target_health = true
  }
}
