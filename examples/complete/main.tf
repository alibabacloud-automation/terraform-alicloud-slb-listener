variable "profile" {
  default = "default"
}
variable "region" {
  default = "cn-hangzhou"
}

provider "alicloud" {
  region  = var.region
  profile = var.profile
}

data "alicloud_zones" "this" {
  available_instance_type = "ecs.s6-c1m1.small"
  available_resource_creation = "VSwitch"
}

#############################################################
# Data sources to get VPC, vswitch and default security group details
#############################################################
module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_name           = "my_module_vpc"
  vpc_cidr           = "172.16.0.0/16"
  vswitch_name       = "my_module_vswitch"
  vswitch_cidrs      = ["172.16.1.0/24"]
  availability_zones = [data.alicloud_zones.this.ids.0]
}

module "security-group" {
  source  = "alibaba/security-group/alicloud"
  name        = "user-service"
  description = "Security group for user-service with custom rules of source security group."
  vpc_id      = module.vpc.vpc_id
}

// ECS Module
module "ecs_instance" {
  source                      = "alibaba/ecs-instance/alicloud//modules/x86-architecture-general-purpose"
  profile                     = var.profile
  region                      = var.region
  number_of_instances         = 2
  instance_type_family        = "ecs.s6-c1m1"
  instance_type               = "ecs.s6-c1m1.small"
  vswitch_id                  = module.vpc.vswitch_ids[0]
  security_group_ids          = [module.security-group.this_security_group_id]
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
  source              = "../../"
  profile             = var.profile
  region              = var.region
  slb                 = module.slb.this_slb_id
  listeners           = [
    {
      server_group_ids  = module.slb.this_slb_virtual_server_group_id
      backend_port      = "80"
      frontend_port     = "80"
      protocol          = "tcp"
      bandwidth         = var.bandwidth
      scheduler         = var.scheduler
      healthy_threshold = var.healthy_threshold
      gzip              = var.gzip
      health_check_type = var.health_check_type
    }
  ]
  health_check        = var.health_check
  advanced_setting    = var.advanced_setting
  x_forwarded_for     = var.x_forwarded_for
  ssl_certificates    = var.ssl_certificates
}



