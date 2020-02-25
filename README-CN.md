Alibaba Cloud Load Balancer (SLB) Listener Terraform Module
terraform-alicloud-slb-listener
=====================================================================

本 Module 用于在阿里云上快速创建slb listeners资源 

本 Module 支持创建以下资源:

* [API Slb Listener](https://www.terraform.io/docs/providers/alicloud/r/slb_listener.html)

## Terraform 版本

本 Module 要求使用 Terraform 0.12 和 阿里云 Provider 1.56.0+。

## 用法

```hcl
module "slb_listener" {
  source  = "terraform-alicloud-modules/slb-listener/alicloud"
  profile = "Your-Profile-Name"
  region  = "cn-beijing"
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
  
  // 您也可以选择不填此项以使用默认值
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
  
  // 您也可以选择不填此项以使用默认值
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
  
  // 您也可以选择不填此项以使用默认值
  x_forwarded_for = {
    retrive_slb_ip    = "true"
    retrive_slb_id    = "false"
    retrive_slb_proto = "true"
  }
  
  // 您也可以选择不填此项以使用默认值
  ssl_certificates = {
    tls_cipher_policy = "tls_cipher_policy_1_0"
  }
}

```

## 示例

* [基础示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-slb-listener/tree/master/examples/basic-example)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Wang li(@Lexsss, 13718193219@163.com) and He Guimin(@xiaozhu36, heguimin36@163.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
