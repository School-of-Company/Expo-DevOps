output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.expo-alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.expo-alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.expo-tg.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.expo-tg.name
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = var.enable_https ? aws_lb_listener.https[0].arn : null
} 