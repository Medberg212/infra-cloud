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

data "template_file" "init" {
  template = file("${path.module}/bootstrap.sh")
  vars = {
    fs_id = aws_efs_mount_target.mount1.dns_name
  }
}

resource "aws_instance" "nextcloud" {
  ami           = "ami-08b1d20c6a69a7100"
  instance_type = "t3.micro"
  user_data              = data.template_file.init.rendered

  network_interface {
    network_interface_id = aws_network_interface.nextcloud_new.id
    device_index         = 0
  }
  key_name = aws_key_pair.nextcloud.key_name

  tags = {
    Name = "${local.name}-nextcloud"
  }

}