resource "aws_launch_template" "ami_ubuntu" {
  name = "template_mberguella"

  image_id = data.aws_ami.ami_ubuntu.id

  instance_type = "t3.micro"
  update_default_version = true

  key_name = aws_key_pair.nextcloud.key_name

  vpc_security_group_ids = [aws_security_group.allow_ssh_private.id]

  tags = {
    Name  = "${local.user}-${local.tp}-launch-template"
    Owner = local.user
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name  = "${local.name}-nextcloud"
      Owner = local.user
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name  = "${local.user}-${local.tp}-volume"
      Owner = local.user
    }
  }

  tag_specifications {
    resource_type = "network-interface"

    tags = {
      Name  = "${local.user}-${local.tp}-nic"
      Owner = local.user
    }
  }
}