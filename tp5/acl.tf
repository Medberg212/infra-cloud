resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.my_vpc.id


  ingress {
    protocol   = "tcp"
    rule_no    = 1
    action     = "deny"
    cidr_block = "13.48.4.200/30"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


}