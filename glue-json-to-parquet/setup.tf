# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "glue_bucket_source" {
  bucket = "glue-bucket-source-${local.random}"
  acl    = "private"

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.bucket} --recursive"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "glue_bucket_definition" {
  bucket = "glue-bucket-definition-${local.random}"
  acl    = "private"

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.bucket} --recursive"
  }
}

# ----------------------------------------------------------------------------------------------
# Upload Test file
# ----------------------------------------------------------------------------------------------
resource "null_resource" "setup" {
  triggers = {
    file_content_md5 = filemd5("${path.module}/datas/cloudtrail_logs.gz")
  }

  provisioner "local-exec" {
    command = "aws s3 cp ./datas/cloudtrail_logs.gz s3://${aws_s3_bucket.glue_bucket_source.bucket}"
  }
}
