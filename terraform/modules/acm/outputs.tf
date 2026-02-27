output "certificate_arn" {
  description = "ARN del certificado ACM (validado)"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

