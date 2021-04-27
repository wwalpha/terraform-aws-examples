# ----------------------------------------------------------------------------------------------
# IAM Service Role - Glue
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "glue_crawler" {
  name = "AWSGlueServiceRole-CloudTrail-${local.random}"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Service Role Policy Attachment - Glue
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "glue_crawler_policy" {
  role       = aws_iam_role.glue_crawler.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# ----------------------------------------------------------------------------------------------
# IAM Policy - Glue
# ----------------------------------------------------------------------------------------------
resource "aws_iam_policy" "glue_crawler_inline_policy" {
  name = "s3_Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:*"
        ],
        "Effect" : "Allow",
        "Resource" : "${aws_s3_bucket.glue_bucket_source.arn}/*"
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Service Role Policy Attachment - Glue Inline Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "glue_crawler_inline_policy_attach" {
  role       = aws_iam_role.glue_crawler.id
  policy_arn = aws_iam_policy.glue_crawler_inline_policy.arn
}
