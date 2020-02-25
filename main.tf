provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/slb-listener"
}

locals {
  listeners = flatten(
    [
      for _, obj in var.listeners : [
        for _, id in split(",", lookup(obj, "server_group_ids")) : {
          server_group_id           = id
          backend_port              = lookup(obj, "backend_port")
          frontend_port             = lookup(obj, "frontend_port")
          protocol                  = lookup(obj, "protocol")
          bandwidth                 = lookup(obj, "bandwidth", "-1")
          scheduler                 = lookup(obj, "scheduler", "wrr")
          health_check              = lookup(obj, "health_check", lookup(var.health_check, "health_check", "off"))
          health_check_type         = lookup(obj, "health_check_type", lookup(var.health_check, "health_check_type", null))
          healthy_threshold         = lookup(obj, "healthy_threshold", lookup(var.health_check, "healthy_threshold", 3))
          unhealthy_threshold       = lookup(obj, "unhealthy_threshold", lookup(var.health_check, "unhealthy_threshold", 3))
          health_check_timeout      = lookup(obj, "health_check_timeout", lookup(var.health_check, "health_check_timeout", 5))
          health_check_interval     = lookup(obj, "health_check_interval", lookup(var.health_check, "health_check_interval", 2))
          health_check_connect_port = lookup(obj, "health_check_connect_port", lookup(var.health_check, "health_check_connect_port", lookup(obj, "backend_port")))
          health_check_domain       = lookup(obj, "health_check_domain", lookup(var.health_check, "health_check_domain", null))
          health_check_uri          = lookup(obj, "health_check_uri", lookup(var.health_check, "health_check_uri", "/"))
          health_check_http_code    = lookup(obj, "health_check_http_code", lookup(var.health_check, "health_check_http_code", "http_2xx"))
          health_check_method       = lookup(obj, "health_check_method", lookup(var.health_check, "health_check_method", null))
          sticky_session            = lookup(obj, "sticky_session", lookup(var.advanced_setting, "sticky_session", "off"))
          sticky_session_type       = lookup(obj, "sticky_session_type", lookup(var.advanced_setting, "sticky_session_type", "server"))
          cookie                    = lookup(obj, "cookie", lookup(var.advanced_setting, "cookie", null))
          cookie_timeout            = lookup(obj, "cookie_timeout", lookup(var.advanced_setting, "cookie_timeout", "86400"))
          gzip                      = lookup(obj, "gzip", lookup(var.advanced_setting, "gzip", "false"))
          persistence_timeout       = lookup(obj, "persistence_timeout", lookup(var.advanced_setting, "persistence_timeout", null))
          established_timeout       = lookup(obj, "established_timeout", lookup(var.advanced_setting, "established_timeout", null))
          acl_status                = lookup(obj, "acl_status", lookup(var.advanced_setting, "acl_status", "off"))
          acl_type                  = lookup(obj, "acl_type", lookup(var.advanced_setting, "acl_type", null))
          acl_id                    = lookup(obj, "acl_id", lookup(var.advanced_setting, "acl_id", null))
          idle_timeout              = lookup(obj, "idle_timeout", lookup(var.advanced_setting, "idle_timeout", null))
          request_timeout           = lookup(obj, "request_timeout", lookup(var.advanced_setting, "request_timeout", null))
          retrive_slb_ip            = lookup(obj, "retrive_slb_ip", lookup(var.x_forwarded_for, "retrive_slb_ip", false))
          retrive_slb_id            = lookup(obj, "retrive_slb_id", lookup(var.x_forwarded_for, "retrive_slb_id", false))
          retrive_slb_proto         = lookup(obj, "retrive_slb_proto", lookup(var.x_forwarded_for, "retrive_slb_proto", false))
          tls_cipher_policy         = lookup(obj, "tls_cipher_policy", lookup(var.ssl_certificates, "tls_cipher_policy", null))
          server_certificate_id     = lookup(obj, "server_certificate_id", lookup(var.ssl_certificates, "server_certificate_id", null))
          enable_http2              = lookup(obj, "enable_http2", lookup(var.ssl_certificates, "enable_http2", null))
        }
      ]
    ]
  )
}

resource "alicloud_slb_listener" "this" {
  count            = var.create ? length(local.listeners) : 0
  load_balancer_id = var.slb
  backend_port     = lookup(local.listeners[count.index], "backend_port")
  frontend_port    = lookup(local.listeners[count.index], "frontend_port")
  protocol         = lookup(local.listeners[count.index], "protocol")
  bandwidth        = lookup(local.listeners[count.index], "bandwidth", "-1")
  scheduler        = lookup(local.listeners[count.index], "scheduler", "wrr")
  server_group_id  = lookup(local.listeners[count.index], "server_group_id")

  // Health Check
  healthy_threshold         = lookup(local.listeners[count.index], "healthy_threshold")
  unhealthy_threshold       = lookup(local.listeners[count.index], "unhealthy_threshold")
  health_check_timeout      = lookup(local.listeners[count.index], "health_check_timeout")
  health_check_interval     = lookup(local.listeners[count.index], "health_check_interval")
  health_check_connect_port = lookup(local.listeners[count.index], "health_check_connect_port")
  health_check_domain       = lookup(local.listeners[count.index], "health_check_domain")
  health_check_uri          = lookup(local.listeners[count.index], "health_check_uri")
  health_check_http_code    = lookup(local.listeners[count.index], "health_check_http_code")
  health_check_type         = lookup(local.listeners[count.index], "health_check_type")

  // Advance setting
  sticky_session      = lookup(local.listeners[count.index], "sticky_session")
  sticky_session_type = lookup(local.listeners[count.index], "sticky_session_type")
  cookie              = lookup(local.listeners[count.index], "cookie")
  cookie_timeout      = lookup(local.listeners[count.index], "cookie_timeout")
  health_check        = lookup(local.listeners[count.index], "health_check")
  gzip                = lookup(local.listeners[count.index], "gzip")
  persistence_timeout = lookup(local.listeners[count.index], "persistence_timeout")
  established_timeout = lookup(local.listeners[count.index], "established_timeout")
  acl_status          = lookup(local.listeners[count.index], "acl_status")
  acl_type            = lookup(local.listeners[count.index], "acl_type")
  acl_id              = lookup(local.listeners[count.index], "acl_id")
  idle_timeout        = lookup(local.listeners[count.index], "idle_timeout")
  request_timeout     = lookup(local.listeners[count.index], "request_timeout")

  // x_forwarded_for setting
  x_forwarded_for {
    retrive_slb_ip    = lookup(local.listeners[count.index], "retrive_slb_ip")
    retrive_slb_id    = lookup(local.listeners[count.index], "retrive_slb_id")
    retrive_slb_proto = lookup(local.listeners[count.index], "retrive_slb_proto")
  }

  // Ssl certificate setting
  server_certificate_id = lookup(local.listeners[count.index], "server_certificate_id")
  tls_cipher_policy     = lookup(local.listeners[count.index], "tls_cipher_policy")
  enable_http2          = lookup(local.listeners[count.index], "enable_http2")
}


