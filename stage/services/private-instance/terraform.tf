terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "devfloors"

    workspaces {
      name = "terraform-k8s-boilerplate-private-ec2"
    }
  }
}

output "context" {
  value =  yamldecode(file(var.config_file)).context
}

output "config" {
  value = yamldecode(templatefile(var.config_file, local.context))
}

locals {
  context = yamldecode(file(var.config_file)).context
  config  = yamldecode(templatefile(var.config_file, local.context))
}

locals {
  remote_states = {
    "network" = data.tfe_outputs.this["network"].values
  }

  vpc_id = local.remote_states["network"].vpc_id
  public_subnets = local.remote_states["network"].public_subnets
  private_subnets = local.remote_states["network"].private_subnets
}

provider "aws" {
  region = "ap-northeast-2"
  shared_credentials_file = "~/.aws/credentials"
}
