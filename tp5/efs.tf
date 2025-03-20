resource "aws_efs_file_system" "fs1" {

  creation_token = "fs1"
  encrypted      = true
  kms_key_id     = aws_kms_key.kms_key.arn
}

resource "aws_efs_mount_target" "mount1" {
  file_system_id  = aws_efs_file_system.fs1.id
  subnet_id       = aws_subnet.private_1a.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount2" {
  file_system_id  = aws_efs_file_system.fs1.id
  subnet_id       = aws_subnet.private_1b.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount3" {
  file_system_id  = aws_efs_file_system.fs1.id
  subnet_id       = aws_subnet.private_1c.id
  security_groups = [aws_security_group.efs_sg.id]
}
