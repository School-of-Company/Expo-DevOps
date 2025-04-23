resource "aws_iam_role_policy_attachment" "bastion_admin_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}