resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  instance_class       = "db.t4g.micro"
  username             = "toto"
  password             = "totototo"
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  identifier = "${local.name}-db"
  vpc_security_group_ids = [aws_security_group.instance_db.id]
  multi_az=true
}