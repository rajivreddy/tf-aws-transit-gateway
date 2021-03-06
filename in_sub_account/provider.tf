provider "aws" {
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

provider "aws" {
  alias                   = "source"
  version                 = "> 2.14.0"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.source_profile
}

