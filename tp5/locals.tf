locals {
  user = "mberguella"                 # Change this to your own username
  tp   = basename(abspath(path.root)) # Get the name of the current directory
  name = "${local.user}-${local.tp}"  # Concatenate the username and the directory name
  tags = {                            # Define a map of tags to apply to all resources
    Name  = local.name
    Owner = local.user
  }
}