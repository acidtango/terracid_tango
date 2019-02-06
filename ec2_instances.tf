resource "aws_security_group" "ec2_host_sg" {
  name        = "EC2_SG"
  description = "Security Group for EC2 hosts on Private Network"
  vpc_id      = "${aws_vpc.main.id}"

  # Allow all from Bastion, LoadBalancer and Self
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion_sg.id}", "${aws_security_group.lb_sg.id}"]
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_host1" {
  ami                    = "${lookup(var.rancher_amis, var.aws_region)}"
  subnet_id              = "${aws_subnet.private_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_host_sg.id}"]
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"

  tags {
    Name = "EC2 Example Host"
  }
}

resource "aws_instance" "ec2_host2" {
  ami                    = "${lookup(var.rancher_amis, var.aws_region)}"
  subnet_id              = "${aws_subnet.private_subne2.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_host_sg.id}"]
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"

  tags {
    Name = "EC2 Example Host"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.ec2_tg.arn}"
  target_id        = "${aws_instance.ec2_host.id}"
}
