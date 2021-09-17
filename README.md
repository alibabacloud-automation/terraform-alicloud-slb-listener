Alibaba Cloud Load Balancer (SLB) Listener Terraform Module
terraform-alicloud-slb-listener
=====================================================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-slb-listener/blob/master/README-CN.md)

Terraform module which creates slb listener resources on Alibaba Cloud.

These types of resources are supported:

* [Slb Listener](https://www.terraform.io/docs/providers/alicloud/r/slb_listener.html)

## Terraform versions

The Module requires Terraform 0.12 and Terraform Provider AliCloud 1.56.0+.

## Usage

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

* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

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
