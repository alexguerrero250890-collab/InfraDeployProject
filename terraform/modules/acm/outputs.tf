output "certificate_arn" {
  description = "ARN del certificado ACM"
  value       = aws_acm_certificate.this.arn
}

