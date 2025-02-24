resource "aws_security_group" "allow_ssh_public" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.name}-bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh_public.id
  cidr_ipv4         = "13.38.29.162/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "allow_ssh_private" {
  name        = "allow_ssh_private"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.name}-nextcloud"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_private" {
  security_group_id            = aws_security_group.allow_ssh_private.id
  referenced_security_group_id = aws_security_group.allow_ssh_public.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_private" {
  security_group_id = aws_security_group.allow_ssh_private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "EFS security group"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.name}-efs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "efs_sg_in" {
  security_group_id            = aws_security_group.efs_sg.id
  referenced_security_group_id = aws_security_group.allow_ssh_private.id
  ip_protocol                  = -1
}

