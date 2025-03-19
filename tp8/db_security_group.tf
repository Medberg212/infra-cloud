resource "aws_security_group" "instance_db" {
  name        = "instance_db"
  description = "Allow inbound traffic from nextcloud instance and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.name}-DB"
  }
}

resource "aws_vpc_security_group_ingress_rule" "in_db" {
  security_group_id            = aws_security_group.instance_db.id
  referenced_security_group_id = aws_security_group.allow_ssh_private.id
  ip_protocol                  = "-1"
}


resource "aws_vpc_security_group_egress_rule" "out_db" {
  security_group_id = aws_security_group.instance_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}