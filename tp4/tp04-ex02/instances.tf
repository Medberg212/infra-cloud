resource "aws_instance" "bastion" {
  ami           = "ami-08b1d20c6a69a7100"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.bastion_new.id
    device_index         = 0
  }
  key_name = aws_key_pair.bastion.key_name

  tags = {
    Name = "${local.name}-bastion"
  }

}

resource "aws_instance" "nextcloud" {
  ami           = "ami-08b1d20c6a69a7100"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.nextcloud_new.id
    device_index         = 0
  }
  key_name = aws_key_pair.nextcloud.key_name

  tags = {
    Name = "${local.name}-nextcloud"
  }

}