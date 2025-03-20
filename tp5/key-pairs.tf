resource "aws_key_pair" "nextcloud" {
  key_name   = "${local.name}-nextcloud"
  public_key = tls_private_key.nextcloud.public_key_openssh
}

resource "aws_key_pair" "bastion" {
  key_name   = "${local.name}-bastion"
  public_key = tls_private_key.bastion.public_key_openssh
}



# RSA key of size 4096 bits
resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ED25519 key
resource "tls_private_key" "nextcloud" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "private_bastion" {
  content  = tls_private_key.bastion.private_key_openssh
  filename = "${path.module}/ssh/bastion.pem"
}

resource "local_sensitive_file" "private_nextcloud" {
  content  = tls_private_key.nextcloud.private_key_openssh
  filename = "${path.module}/ssh/nextcloud.pem"
}

