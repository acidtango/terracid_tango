resource "aws_s3_bucket" "primary" {
  provider      = aws.main
  bucket        = var.s3_bucket.name
  acl           = "private"
  force_destroy = true
  policy        = <<POLICY
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_root",
      "Action": ["s3:ListBucket"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3_bucket.name}",
      "Principal": {"AWS":"${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"}
    },
    {
      "Sid": "bucket_policy_site_all",
      "Action": ["s3:GetObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3_bucket.name}/*",
      "Principal": {"AWS":"${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"}
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = var.s3_bucket.tags
}
