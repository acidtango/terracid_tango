output "alb_dns_name" {
  value = aws_lb.public_lb.dns_name
}

output "bastion_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "ec2_instances_ip" {
  value = [aws_instance.ec2_host1.private_ip, aws_instance.ec2_host2.private_ip]
}

