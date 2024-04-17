data "aws_canonical_user_id" "current" {}

resource "aws_cloudtrail" "cloudtrail" {
  depends_on = [
    aws_s3_bucket_policy.cloudtrail
  ]

  name                          = "cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = ""
  include_global_service_events = false
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "s3-neccdl-2024-${var.team_number}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  depends_on = [
    aws_s3_bucket_ownership_controls.cloudtrail
  ]

  bucket = aws_s3_bucket.cloudtrail.id
  policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AWSCloudTrailAclCheck",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${aws_s3_bucket.cloudtrail.arn}"
        },
        {
          "Sid": "AWSCloudTrailWrite",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.cloudtrail.arn}/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        }
      ]
    }
  POLICY
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "cloudtrail" {
  depends_on = [
    aws_s3_bucket_ownership_controls.cloudtrail
  ]

  bucket = aws_s3_bucket.cloudtrail.id
  access_control_policy {
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      }
      permission = "READ"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        type = "CanonicalUser"
        id   = data.aws_canonical_user_id.current.id
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

resource "aws_s3_account_public_access_block" "account" {
  block_public_acls   = false
  block_public_policy = false
}
