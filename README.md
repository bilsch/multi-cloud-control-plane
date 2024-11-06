# multi-cloud-control-plane

This is a reference architecture to have a multi-cloud control plane. The idea is that each directory is prefixed with a 3-digit number to indicate order and a name. For example:

005-terraform-state
020-vpc
030-kubernetes

The apply order would be 005, then 020 and finally 030. The destroy order would be the reverse.

# stage and terraform state

At the moment all of the stages are using consul for state management. The intent is to use something like terragrunt or manually craft our own state.tf via the run_tf wrappers in a consistent maner the same way terragrunt would.

At some point in the future this will change to something more robust. The stage creates the necessary resources I'm just lazy and not using it yet - focusing elsewhere.

# Stage structure

The directory strucutre within a given stage is fairly simple. The first directory is the cloud provider. Within the cloud provider directory you place the terraform code you want to run. The goal is that most of the terraform code in each provider directory is either setting up terraform, data lookups or module calls. There should be no resource manipulation within these - save that for the modules you call.

The general structure for a given provider stage:

| file    | purpose |
| ------- | ------- |
| data.tf | Data lookups needed by your module calls |
| terraform.tf | Configure your providers |
| main.tf | This is where your module calls should be placed |
| vault_outputs.tf | Any module outputs should be placed in vault secrets. This allows future stages to reference them safely and without needing to update yaml files etc |

# main.tf flow

The main.tf content should be fairly simple. Load the yaml config, maybe have some local variables, call your module(s).

```yaml
locals {
  config = yamldecode(file("/path/to/multi-cloud-control-configs/clouds/aws/${var.profile}.yaml"))

  foo = local.config.foo
}

module "vpc" {
  source = "foo"
  (...)
  foo = local.foo
}
```

# vault_outputs.tf structure

The structure of the vault_outputs.tf is still somewhat up in the air. The basic idea is that each stage should set a secret with data elements necessary for other stages to consume it's work. The hope is that this is only going to contain things which cannot be obtained by a data lookup - getting the vpc's vpc_id to pass on since we can't look up a vpc via a name for instance.

The format generically is as below. This is a shortened version of the vpc output.

```
resource "vault_kv_secret_v2" "this" {
  mount               = "secret"
  name                = "multi-cloud/aws/${var.profile}/vpc"
  delete_all_versions = true

  data_json = jsonencode({
    "vpc_id"              = module.vpc.vpc_id,
  })
}

```

Note that I'm not putting the order number in just the stage name.