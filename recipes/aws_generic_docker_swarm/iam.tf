resource "aws_iam_role" "ec2_host_role" {
  name = "ec2_host_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    }
  }]
}
EOF

}

# This policy is needed for the containers to be able to write in CloudWatch
resource "aws_iam_role_policy" "logs_policy" {
  name = "logs_policy"
  role = aws_iam_role.ec2_host_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_host_role.name
}

