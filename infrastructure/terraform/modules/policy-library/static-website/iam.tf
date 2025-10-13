locals {
  s3_bucket_namespace_arn = "arn:aws:s3:::${var.prefix}-*"
  s3_object_namespace_arn = "arn:aws:s3:::${var.prefix}-*/*"
}

data "aws_iam_policy_document" "this" {
  # Bucket creation cannot be scoped to a specific ARN because the bucket does not exist yet.
  statement {
    sid    = "S3WebsiteBucketCreate"
    effect = "Allow"
    actions = [
      "s3:CreateBucket"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "S3WebsiteBucketManagement"
    effect = "Allow"
    actions = [
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:PutBucketVersioning",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketTagging",
      "s3:PutBucketAcl",
      "s3:PutBucketCORS",
      "s3:PutBucketWebsite",
      "s3:Get*"
    ]
    resources = [
      local.s3_bucket_namespace_arn
    ]
  }

  statement {
    sid    = "S3WebsiteObjectManagement"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:DeleteObject"
    ]
    resources = [
      local.s3_object_namespace_arn
    ]
  }

  statement {
    sid    = "CloudFront"
    effect = "Allow"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:ListTagsForResource",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:ListDistributions"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "ACMCertificateManagement"
    effect = "Allow"
    actions = [
      "acm:RequestCertificate",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:DeleteCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:ListTagsForCertificate"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "R53"
    effect = "Allow"
    actions = [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:GetChange"
    ]
    resources = [
      "*"
    ]
  }
}
