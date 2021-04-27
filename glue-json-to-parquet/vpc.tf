# ----------------------------------------------------------------------------------------------
# AWS VPC
# ----------------------------------------------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "glue-vpc"
  cidr                 = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  azs                  = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]

  tags = {
    Environment = "demo"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - Allow all
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "allow_all_sg" {
  name        = "glue_allow_all_sg"
  description = "Allow All traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "glue_allow_all_sg"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - S3
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    "Name" = "glue-endpoint-s3"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Route Table Association - Private Subnet
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_route_table_association" "private_route_table1" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = module.vpc.private_route_table_ids[0]
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Route Table Association - Private Subnet
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_route_table_association" "private_route_table2" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = module.vpc.private_route_table_ids[1]
}


