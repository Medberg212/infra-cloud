resource "aws_iam_role" "role" {
  name = "${local.user}-nextcloud"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "policy" {
  name = "${local.user}-nextcloud"
  role = aws_iam_role.role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Statement1"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = ["${aws_s3_bucket.bucket.arn}/*",
        aws_s3_bucket.bucket.arn]
      }
    ]
  })


}



resource "aws_iam_instance_profile" "profil" {
  name = "${local.user}-nextcloud"
  role = aws_iam_role.role.name
}

data "aws_iam_user" "user" {
  user_name = local.user
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyActOnObject"
        Effect = "Deny"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.bucket.arn}/*"
        ]
        Principal = {
          AWS = data.aws_iam_user.user.arn
        }
      },
      {
        Sid    = "DenyAllExceptActsNextcloud"
        Effect = "Deny"
        NotAction = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = ["${aws_s3_bucket.bucket.arn}/*",
        aws_s3_bucket.bucket.arn]
        Principal = {
          AWS = aws_iam_role.role.arn
        }
      },
      {
        Sid    = "DenyAllExceptAuthorized"
        Effect = "Deny"
        Action = "*"
        Resource = [
          "${aws_s3_bucket.bucket.arn}/*",
          aws_s3_bucket.bucket.arn
        ]
        Principal = "*"
        Condition = {
          "StringNotEquals" = {
            "aws:PrincipalArn" = [
              data.aws_iam_user.user.arn, # Ton utilisateur IAM
              aws_iam_role.role.arn       # Ton rôle Nextcloud
            ]
          }
        }
      }
    ]
  })
}
