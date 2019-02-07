output "alb_dns_name" {
  value = "${aws_lb.public_lb.dns_name}"
}

output "bastion_ip" {
  value = "${aws_instance.bastion_host.public_ip}"
}
