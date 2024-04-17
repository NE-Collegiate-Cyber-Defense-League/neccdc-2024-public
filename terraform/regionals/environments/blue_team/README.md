

All team subaccounts need a IAM role that can be assumed called `black-team` with the following permissions.

[AdministratorAccess](https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AdministratorAccess$serviceLevelSummary)

Description: `Black Team - Do NOT remove`

Trust policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::0123456789:user/ME",
                  "arn:aws:iam::0123456789:root"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

Allows the role to be assumed by my personal AWS account and the black team account.
