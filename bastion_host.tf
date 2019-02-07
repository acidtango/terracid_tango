resource "aws_security_group" "bastion_sg" {
  name        = "BastionSG"
  description = "Security Group for Bastion Host"
  vpc_id      = "${aws_vpc.main.id}"

  # Allow ssh access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {
  ami                    = "${lookup(var.centos_amis, var.aws_region)}"
  subnet_id              = "${aws_subnet.public_subnet_1.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"

  tags {
    Name = "Bastion"
  }
}
