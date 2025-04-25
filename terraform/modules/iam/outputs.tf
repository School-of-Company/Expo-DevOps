output "bastion_instance_profile_name" {
  description = "Name of the IAM instance profile for the bastion host"
  value       = aws_iam_instance_profile.bastion_profile.name
}
