resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${local.name}-nextcloud"
  force_destroy = true
}