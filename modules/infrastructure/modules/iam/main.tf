
resource "aws_iam_role_policy" "dynamodb_readonly_policy" {
  name = "events-${var.environment}-dynamodb-readonly-policy"
  role = "${aws_iam_role.dynamodb_readonly_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:Scan",
                "dynamodb:Query"
            ],
            "Resource": "${var.dynamodb-events-table-arn}"
        }
    ]
  }
EOF
}

resource "aws_iam_role" "dynamodb_readonly_role" {
  name = "events-${var.environment}-dynamodb-readonly-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${var.identity-pool-id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}