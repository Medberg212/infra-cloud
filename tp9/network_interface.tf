resource "aws_network_interface" "bastion_new" {
  subnet_id       = aws_subnet.public_1a.id
  security_groups = [aws_security_group.allow_ssh_public.id]

  tags = {
    Name = "${local.name}-bastion_new"
  }
}

resource "aws_network_interface" "nextcloud_new" {
  subnet_id       = aws_subnet.private_1b.id
  security_groups = [aws_security_group.allow_ssh_private.id]
  tags = {
    Name = "${local.name}-nextcloud_new"
  }
}