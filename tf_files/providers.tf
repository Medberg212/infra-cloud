provider "aws" {
  profile = "formation-infra-cloud"
  region  = "eu-north-1"

  default_tags {
    tags = {
      Owner = "mberguella" # à remplacer par votre utilisateur AWS
    }
  }
}