resource "aws_organizations_policy" "restrict_leave_org" {
  name        = "RestrictLeavingOrganization"
  description = "Deny accounts from leaving the organization"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "aws-portal:ModifyAccount",
          "aws-portal:ModifyPaymentMethods"
        ]
        Effect   = "Deny"
        Resource = "*"
      },
      {
        Action   = "organizations:LeaveOrganization"
        Effect   = "Deny"
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy" "restrict_instance_types" {
  name        = "RestrictInstanceTypes"
  description = "Specify what instance types can be launched by an account"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "ec2:RunInstances"
        Condition = {
          StringNotEquals = {
            "ec2:InstanceType" = [
              "t3.nano",
              "t3.micro",
              "t3.small",
              "t3.medium",
              "t3.large",
              "t3a.nano",
              "t3a.micro",
              "t3a.small",
              "t3a.medium",
              "t3a.large"
            ]
          }
        }
        Effect   = "Deny"
        Resource = "arn:aws:ec2:*:*:instance/*"
        Sid      = "RequiredInstanceType"
      }
    ]
  })
}

resource "aws_organizations_policy" "service_allow_list" {
  name        = "RestrictAmazonServices"
  description = "Restrict which services can be accessed"
  content = jsonencode({
    Statement = [
      {
        Condition = {
          ArnNotLike = {
            "aws:PrincipalARN" = [
              "arn:aws:iam::*:role/black-team",
              "arn:aws:iam::*:user/ORG/black-team"
            ]
          }
          StringNotEqualsIfExists = {
            "aws:RequestedRegion" = "us-east-2"
          }
        }
        Effect = "Deny"
        NotAction = [
          "iam:*",
          "access-analyzer:*",
          "s3:*",
          "sts:*"
        ]
        Resource  = "*"
        Sid = "DenyAllOutsideUsEast2"
      },
      {
        Condition = {
          ArnNotLike = {
            "aws:PrincipalARN" = [
              "arn:aws:iam::*:role/black-team",
              "arn:aws:iam::*:user/ORG/black-team"
            ]
          }
        }
        Effect = "Deny"
        NotAction = [
          "ec2:*",
          "iam:*",
          "access-analyzer:*",
          "s3:*",
          "sts:*",
          "ssm:*",
          "ssmmessages:*",
          "ec2messages:*",
          "cloudtrail:*",
          "autoscaling:Describe*",
          "neccdl:*",
          "elasticloadbalancing:Describe*",
          "cloudwatch:Describe*"
        ]
        Resource = "*"
        Sid      = "DenyAllButSomeResources"
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_organizations_policy" "prevent_black_team_removal" {
  name        = "PreventBlackTeamRemoval"
  description = "Deny accounts from tampering with black-team resources"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "iam:*",
        Condition = {
          ArnNotLike = {
            "aws:PrincipalARN" = [
              "arn:aws:iam::*:role/black-team",
              "arn:aws:iam::*:user/ORG/black-team"
            ]
          }
        }
        Effect   = "Deny"
        Resource = [
          "arn:aws:iam::*:role/black-team",
          "arn:aws:iam::*:user/ORG/black-team"
        ]
      }
    ]
  })
}
