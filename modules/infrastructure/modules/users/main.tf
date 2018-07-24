resource "aws_iam_policy" "rpi_automator_policy" {
  name = "rpi_automator_policy_${var.environment}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutAnalyticsConfiguration",
                "s3:PutAccelerateConfiguration",
                "s3:ReplicateTags",
                "s3:RestoreObject",
                "s3:PutEncryptionConfiguration",
                "s3:ReplicateObject",
                "s3:AbortMultipartUpload",
                "s3:PutBucketTagging",
                "s3:PutLifecycleConfiguration",
                "s3:PutObjectTagging",
                "s3:PutBucketVersioning",
                "dynamodb:BatchWriteItem",
                "dynamodb:UpdateTimeToLive",
                "dynamodb:PutItem",
                "s3:PutMetricsConfiguration",
                "s3:PutReplicationConfiguration",
                "s3:PutObjectVersionTagging",
                "dynamodb:UpdateItem",
                "s3:PutBucketCORS",
                "s3:PutInventoryConfiguration",
                "s3:PutObject",
                "s3:PutIpConfiguration",
                "s3:PutBucketNotification",
                "s3:PutBucketWebsite",
                "s3:PutBucketRequestPayment",
                "s3:PutBucketLogging",
                "s3:ReplicateDelete",
                "dynamodb:UpdateTable"
            ],
            "Resource": [
                "${var.s3-events-bucket-arn}/*",
                "${var.s3-events-bucket-arn}",
                "${var.dynamodb-events-table-arn}"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "dynamodb:TagResource",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user" "rpi_automator_user" {
  name = "rpi_automator_user_${var.environment}"
  path = "/"
}

resource "aws_iam_access_key" "rpi_automator_user" {
  user = "${aws_iam_user.rpi_automator_user.name}"
}

resource "aws_iam_user_policy_attachment" "rpi_automator_user_policy_attach" {
    user       = "${aws_iam_user.rpi_automator_user.name}"
    policy_arn = "${aws_iam_policy.rpi_automator_policy.arn}"
}