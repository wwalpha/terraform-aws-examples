# ----------------------------------------------------------------------------------------------
# AWS Glue Connection - S3
# ----------------------------------------------------------------------------------------------
resource "aws_glue_connection" "s3_conn" {
  depends_on = [
    aws_vpc_endpoint_route_table_association.private_route_table1,
    aws_vpc_endpoint_route_table_association.private_route_table2
  ]

  name            = "s3-connection"
  connection_type = "NETWORK"
  connection_properties = {
    "JDBC_ENFORCE_SSL" = "true"
  }

  physical_connection_requirements {
    availability_zone = "ap-northeast-1a"
    security_group_id_list = [
      aws_security_group.allow_all_sg.id
    ]
    subnet_id = module.vpc.private_subnets[0]
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Catalog Database - CloudTrail
# ----------------------------------------------------------------------------------------------
resource "aws_glue_catalog_database" "cloudtrail" {
  name = "cloudtrail_${local.random}"
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Crawlers - CloudTrail
# ----------------------------------------------------------------------------------------------
resource "aws_glue_crawler" "s3" {
  database_name = aws_glue_catalog_database.cloudtrail.name
  name          = "crawler_${local.random}"
  role          = aws_iam_role.glue_crawler.arn

  s3_target {
    path            = "s3://${aws_s3_bucket.glue_bucket_source.bucket}"
    connection_name = aws_glue_connection.s3_conn.name
  }
}
