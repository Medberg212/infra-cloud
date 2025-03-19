data "aws_ami" "ami_ubuntu" {
  most_recent = true
  name_regex  = "^mberguella-tp7-nextcloud"
  owners      = ["self"]

  filter {
    name   = "state"
    values = ["available"]
  }
}