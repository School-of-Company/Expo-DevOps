resource "aws_instance" "bastion" {
  ami                    = "ami-0c9c942bd7bf113a2"  # Amazon Linux 2 AMI
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}