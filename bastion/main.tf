resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(
    var.tags,
    {
      Name = "bastion-host"
    }
  )
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = merge(
    var.tags,
    {
      Name = "bastion-eip"
    }
  )
} 