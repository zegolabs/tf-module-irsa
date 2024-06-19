resource aws_iam_role "irsa" {
  name = var.irsa_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = var.OIDCArn
        }
        Condition = {
          StringLike = {
            "${var.issuerHostPath}" = "system:serviceaccount:${var.namespace}:*"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "parameter_store_access" {
  name   = "parameter-store-secrets-access"
  role   = aws_iam_role.irsa.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
        Resource = [
          "arn:aws:ssm:*:${var.account}:parameter/secret/${var.namespace}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:Decrypt"
        ]
        Resource = [
          "arn:aws:kms:*:${var.account}:key/*"
        ]
        Condition = {
          "ForAnyValue:StringEquals" = {
            "kms:ResourceAliases" = [
              "alias/secret/${var.namespace}"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "additional_service_policy" {
  for_each = var.additional_service_policies
  name   = "additional-service-policy-${index(var.additional_service_policies, each.value)}"
  role   = aws_iam_role.irsa.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      "${each.value}"
    ]
  })
}