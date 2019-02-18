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

resource "aws_launch_template" "swarm_managers" {
  name = "swarm_managers"

  image_id               = "${lookup(var.rancher_amis, var.aws_region)}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.ec2_host_sg.id}"]

  # Ensure the managers are not terminated by accident
  disable_api_termination = true

  # Tags added to the created Instances
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Swarm Manager"
    }
  }

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ec2_profile.name}"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10 # In GB
    }
  }

  # This is used to run on instance initialization
  user_data = "${base64encode("${local.swarm_managers_init_user_data}")}"
}

resource "aws_autoscaling_group" "swarm_managers_asg" {
  name = "swarm-managers-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  force_delete              = false
  vpc_zone_identifier       = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]
  target_group_arns         = ["${aws_lb_target_group.ec2_tg.arn}"]

  launch_template {
    id      = "${aws_launch_template.swarm_managers.id}"
    version = "$$Latest"
  }
}

# resource "aws_launch_template" "swarm_workers" {
#   name = "swarm_workers"

#   image_id               = "${lookup(var.rancher_amis, var.aws_region)}"
#   instance_type          = "t2.micro"
#   key_name               = "${var.aws_key_name}"
#   vpc_security_group_ids = ["${aws_security_group.ec2_host_sg.id}"]

#   # Ensure the workers are not terminated by accident
#   disable_api_termination = true

#   # Tags added to the created Instances
#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "Swarm Worker"
#     }
#   }

#   iam_instance_profile {
#     name = "${aws_iam_instance_profile.ec2_profile.name}"
#   }

#   block_device_mappings {
#     device_name = "/dev/sda1"

#     ebs {
#       volume_size = 10 # In GB
#     }
#   }

#   # This is used to run on instance initialization
#   user_data = "${base64encode("${local.swarm_workers_user_data}")}"
# }

# resource "aws_autoscaling_group" "swarm_workers_asg" {
#   name                      = "swarm-workers-asg"
#   max_size                  = 3
#   min_size                  = 1
#   desired_capacity          = 1
#   health_check_grace_period = 300
#   force_delete              = false
#   vpc_zone_identifier       = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]
#   target_group_arns         = ["${aws_lb_target_group.ec2_tg.arn}"]

#   launch_template {
#     id      = "${aws_launch_template.swarm_workers.id}"
#     version = "$$Latest"
#   }
# }
