variable "profile" {
  default = "default"
}
variable "region" {
  default = "cn-hangzhou"
}
variable "zone_id" {
  default = "cn-hangzhou-h"
}

provider "alicloud" {
  region  = var.region
  profile = var.profile
}

#############################################################
# Data sources to get VPC, vswitch and default security group details
#############################################################

data "alicloud_vpcs" "default" {
  is_default = true
}

data "alicloud_security_groups" "default" {
  name_regex = "default"
  vpc_id     = data.alicloud_vpcs.default.ids.0
}

data "alicloud_vswitches" "default" {
  is_default = true
  zone_id    = var.zone_id
}

// If there is no default vswitch, create one.
resource "alicloud_vswitch" "default" {
  count             = length(data.alicloud_vswitches.default.ids) > 0 ? 0 : 1
  availability_zone = var.zone_id
  vpc_id            = data.alicloud_vpcs.default.ids.0
  cidr_block        = cidrsubnet(data.alicloud_vpcs.default.vpcs.0.cidr_block, 4, 15)
}


// ECS Module
module "ecs_instance" {
  source                      = "alibaba/ecs-instance/alicloud//modules/x86-architecture-general-purpose"
  profile                     = var.profile
  region                      = var.region
  number_of_instances         = 2
  instance_type_family        = "ecs.g6"
  vswitch_id                  = length(data.alicloud_vswitches.default.ids) > 0 ? data.alicloud_vswitches.default.ids.0 : concat(alicloud_vswitch.default.*.id, [""])[0]
  security_group_ids          = data.alicloud_security_groups.default.ids
  associate_public_ip_address = true
  internet_max_bandwidth_out  = 10
}

// Slb Module
module "slb" {
  source  = "alibaba/slb/alicloud"
  region  = var.region
  profile = var.profile
  servers_of_virtual_server_group = [
    {
      server_ids = join(",", module.ecs_instance.this_instance_id)
      port       = "80"
      weight     = "100"
      type       = "ecs"
    },
  ]
}

module "slb_listener" {
  source  = "../../"
  profile = var.profile
  region  = var.region
  slb     = module.slb.this_slb_id
  listeners = [
    {
      server_group_ids  = module.slb.this_slb_virtual_server_group_id
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
  health_check = {
    healthy_threshold         = "3"
    unhealthy_threshold       = "3"
    health_check_timeout      = "5"
    health_check_interval     = "2"
    health_check              = "off"
    health_check_connect_port = "80"
    health_check_uri          = "/"
    health_check_http_code    = "http_2xx"
    health_check_type         = "tcp"
  }
  advanced_setting = {
    sticky_session      = "on"
    sticky_session_type = "server"
    cookie_timeout      = "86400"
    gzip                = "false"

  }
  x_forwarded_for = {
    retrive_slb_ip    = "true"
    retrive_slb_id    = "false"
    retrive_slb_proto = "true"
  }
  ssl_certificates = {
    tls_cipher_policy = "tls_cipher_policy_1_0"
  }
}



