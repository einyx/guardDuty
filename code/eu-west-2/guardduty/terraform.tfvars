terragrunt = {
  remote_state {
    backend = "s3"

    config {
      encrypt        = true
      bucket         = "terragrunt-state-ci-eu-west-2"
      key            = "${path_relative_to_include()}/guarduty.tfstate"
      region         = "eu-west-2"
      dynamodb_table = "terragrunt-guarduty-locks"
    }
  }

  terraform {
    source = "git::ssh://git@github.com/einyx/terraform-module-guardduty.git"

    extra_arguments "-var-file" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      optional_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("region.tfvars", "ignore")}",
      ]
    }
  }
}

aws_account_id = ""

aws_region = ""

users = [""]
