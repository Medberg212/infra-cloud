resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds"
  subnet_ids = [aws_subnet.private_1a.id,aws_subnet.private_1b.id,aws_subnet.private_1c.id]
}