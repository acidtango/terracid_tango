resource "aws_security_group" "lb_sg" {
  name        = "ALB_SG"
  description = "Security Group for ALB"
  vpc_id      = "${aws_vpc.main.id}"

  # Allow all
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "public_lb" {
  name               = "Terraform-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets            = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
}

resource "aws_lb_target_group" "ec2_tg" {
  name     = "Terraform-EC2-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_lb_listener" "port_80_listener" {
  load_balancer_arn = "${aws_lb.public_lb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "port_443_listener" {
  load_balancer_arn = "${aws_lb.public_lb.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.default.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ec2_tg.arn}"
  }
}
