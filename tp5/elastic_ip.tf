resource "aws_eip" "eip" {
  instance = aws_instance.nextcloud.id
  domain   = "vpc"
}
