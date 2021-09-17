Alibaba Cloud Load Balancer (SLB) Listener Terraform Module
terraform-alicloud-slb-listener
=====================================================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-slb-listener/blob/master/README-CN.md)

Terraform module which creates slb listener resources on Alibaba Cloud.

These types of resources are supported:

* [Slb Listener](https://www.terraform.io/docs/providers/alicloud/r/slb_listener.html)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.56.0

## Usage

```hcl
module "slb_listener" {
  source  = "terraform-alicloud-modules/slb-listener/alicloud"
  slb     = "lb-bp1xxxxxxxxxxxxxx"
  listeners = [
    {
      server_group_ids  = "rsp-bp1xxxxxxx1,rsp-bp1xxxxxx2"
      backend_port      = "80"
      frontend_port     = "80"
      protocol          = "tcp"
      bandwidth         = "-1"
      scheduler         = "wrr"
      healthy_threshold = "4"
      gzip              = "false"
      health_check_type = "tcp"
    }
  ]
  
  // health_check will apply to all of listeners if health checking is not set in the listeners
  health_check = {
    health_check              = "on"
    health_check_type         = "tcp"
    healthy_threshold         = "3"
    unhealthy_threshold       = "2"
    health_check_timeout      = "5"
    health_check_interval     = "2"
    health_check_connect_port = "80"
    health_check_uri          = "/"
    health_check_http_code    = "http_2xx"
  }
  
  // advanced_setting will apply to all of listeners if some fields are not set in the listeners
  advanced_setting = {
    sticky_session      = "on"
    sticky_session_type = "server"
    cookie_timeout      = "86400"
    gzip                = "false"
    retrive_slb_ip      = "true"
    retrive_slb_id      = "false"
    retrive_slb_proto   = "true"
    persistence_timeout = "5"
  }
  
  // x_forwarded_for will apply to all of listeners if it is not set in the listeners
  x_forwarded_for = {
    retrive_slb_ip    = "true"
    retrive_slb_id    = "false"
    retrive_slb_proto = "true"
  }
  
  // ssl_certificates will apply to all of https listeners if it is not set in the listeners
  ssl_certificates = {
    tls_cipher_policy = "tls_cipher_policy_1_0"
  }
}

```

## Examples

* [Basic example](https://github.com/terraform-alicloud-modules/terraform-alicloud-slb-listener/tree/master/examples/basic-example)

## Notes
From the version v1.3.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/slb-listener"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.2.0:

```hcl
module "slb-listener" {
  source  = "terraform-alicloud-modules/slb-listener/alicloud"
  version     = "1.2.0"
  region      = "cn-hangzhou"
  profile     = "Your-Profile-Name"

  slb     = "lb-bp1xxxxxxxxxxxxxx"
  listeners = [
    {
      server_group_ids  = "rsp-bp1xxxxxxx1,rsp-bp1xxxxxx2"
      backend_port      = "80"
      frontend_port     = "80"
      protocol          = "tcp"
      bandwidth         = "-1"
      scheduler         = "wrr"
      healthy_threshold = "4"
      gzip              = "false"
      health_check_type = "tcp"
    }
  ]
}
```

If you want to upgrade the module to 1.3.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
   region  = "cn-hangzhou"
   profile = "Your-Profile-Name"
}
module "slb-listener" {
  source  = "terraform-alicloud-modules/slb-listener/alicloud"
  slb     = "lb-bp1xxxxxxxxxxxxxx"
  listeners = [
    {
      server_group_ids  = "rsp-bp1xxxxxxx1,rsp-bp1xxxxxx2"
      backend_port      = "80"
      frontend_port     = "80"
      protocol          = "tcp"
      bandwidth         = "-1"
      scheduler         = "wrr"
      healthy_threshold = "4"
      gzip              = "false"
      health_check_type = "tcp"
    }
  ]
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}
module "slb-listener" {
  source  = "terraform-alicloud-modules/slb-listener/alicloud"
  providers = {
    alicloud = alicloud.hz
  }
  slb     = "lb-bp1xxxxxxxxxxxxxx"
  listeners = [
    {
      server_group_ids  = "rsp-bp1xxxxxxx1,rsp-bp1xxxxxx2"
      backend_port      = "80"
      frontend_port     = "80"
      protocol          = "tcp"
      bandwidth         = "-1"
      scheduler         = "wrr"
      healthy_threshold = "4"
      gzip              = "false"
      health_check_type = "tcp"
    }
  ]
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.
More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
