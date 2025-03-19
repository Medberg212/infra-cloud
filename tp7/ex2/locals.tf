locals {
  user = "mberguella"                 # Change this to your own username
  tp   = basename(abspath(path.root)) # Get the name of the current directory
  name = "${local.user}-${local.tp}"  # Concatenate the username and the directory name
  tags = {                            # Define a map of tags to apply to all resources
    Name  = local.name
    Owner = local.user
  }
  nextcloud_userdata = templatefile("nextcloud.sh.tftpl",
    {
      efs_dns = aws_efs_file_system.fs1.dns_name,
      db_name = aws_db_instance.default.db_name,
      db_host = aws_db_instance.default.address,
      db_user = aws_db_instance.default.username,
      db_pass = aws_db_instance.default.password,
      fqdn    = aws_route53_record.nextcloud.fqdn,
  })
}