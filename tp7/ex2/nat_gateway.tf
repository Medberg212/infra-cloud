resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_1a.id

  depends_on = [aws_internet_gateway.my_gw]
}
