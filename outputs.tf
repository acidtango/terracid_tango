output "alb_dns_name" {
  value = "${aws_lb.public_lb.dns_name}"
}
