variable "irsa_role_name" {
  description = "The name of the IAM role for IRSA"
  type        = string
}

variable "oidc_arn" {
  description = "The ARN of the OIDC provider"
  type        = string
}

variable "issuer_host_path" {
  description = "The issuer host path for the OIDC provider"
  type        = string
}

variable "namespace" {
  description = "The namespace of the Kubernetes service account"
  type        = string
}

variable "account" {
  description = "The AWS account ID"
  type        = string
}

variable "additional_service_policies" {
  description = "Additional service policies to attach to the IAM role"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
}
