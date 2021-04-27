# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket Suffix
# ----------------------------------------------------------------------------------------------
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
  lower   = true
}

locals {
  random = random_string.random.id
}
