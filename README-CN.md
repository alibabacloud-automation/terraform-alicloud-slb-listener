Alibaba Cloud Load Balancer (SLB) Listener Terraform Module
terraform-alicloud-slb-listener
=====================================================================

本 Module 用于在阿里云上快速创建slb listeners资源 

本 Module 支持创建以下资源:

* [API Slb Listener](https://www.terraform.io/docs/providers/alicloud/r/slb_listener.html)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.56.0 |

## 用法

```hcl
module "slb_listener" {
  source  = "terraform-alicloud-modules/slb-listener/alicloud"
  slb     = "lb-bp1xxxxxxxxxxxxxx"
  
  // listeners 中可以定义所有的listener相关的参数。
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
  
  // health_check 中定义的参数使用有所有 listeners 中定义的listener，用于对其参数的补充
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
  
  // advanced_setting 中定义的参数使用有所有 listeners 中定义的listener，用于对其参数的补充
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
  
  // x_forwarded_for 中定义的参数使用有所有 http／https listeners 中定义的listener，用于对其参数的补充
  x_forwarded_for = {
    retrive_slb_ip    = "true"
    retrive_slb_id    = "false"
    retrive_slb_proto = "true"
  }
  
  // ssl_certificates 中定义的参数使用有所有 https 的 listeners 中定义的listener，用于对其参数的补充
  ssl_certificates = {
    tls_cipher_policy = "tls_cipher_policy_1_0"
  }
}

```

## 示例

* [基础示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-slb-listener/tree/master/examples/complete)

## 注意事项
本Module从版本v1.3.0开始已经移除掉如下的 provider 的显式设置：
```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/slb-listener"
} 
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.2.0:

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
如果你想对正在使用中的Module升级到 1.3.0 或者更高的版本，那么你可以在模板中显式定义一个相同Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显式指定这个provider：

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

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)