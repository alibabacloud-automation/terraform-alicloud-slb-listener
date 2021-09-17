# Listener common variables
variable "create" {
  description = "Whether to create load balancer listeners."
  type        = bool
  default     = true
}

variable "bandwidth" {
  description = "Bandwidth peak of Listener. "
  type        = string
  default     = "-1"
}

variable "scheduler" {
  description = "Scheduling algorithm, Valid values: wrr, rr, wlc, sch, tcp, qch. Default to wrr. "
  type        = string
  default     = "wrr"
}

variable "healthy_threshold" {
  description = " Threshold determining the result of the health check is success. "
  type        = string
  default     = "4"
}

variable "gzip" {
  description = "Whether to enable Gzip Compression. If enabled, files of specific file types will be compressed, otherwise, no files will be compressed. Default to true."
  type        = bool
  default     = false
}

variable "health_check_type" {
  description = "Type of health check. Valid values are: tcp and http. Default to tcp . "
  type        = string
  default     = "tcp"
}

variable "health_check" {
  description = "The slb listener health check settings to use on listeners. It's supports fields 'healthy_threshold','unhealthy_threshold','health_check_timeout', 'health_check', 'health_check_type', 'health_check_connect_port', 'health_check_domain', 'health_check_uri', 'health_check_http_code', 'health_check_method' and 'health_check_interval'"
  type        = map(string)
  default     = {
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
}

variable "advanced_setting" {
  description = "The slb listener advanced settings to use on listeners. It's supports fields 'sticky_session', 'sticky_session_type', 'cookie', 'cookie_timeout', 'gzip', 'persistence_timeout', 'acl_status', 'acl_type', 'acl_id', 'idle_timeout' and 'request_timeout'."
  type        = map(string)
  default     = {
    sticky_session      = "on"
    sticky_session_type = "server"
    cookie_timeout      = "86400"
    gzip                = "false"
  }
}

variable "x_forwarded_for" {
  description = "Additional HTTP Header field 'X-Forwarded-For' to use on listeners. It's supports fields 'retrive_slb_ip', 'retrive_slb_id' and 'retrive_slb_proto'"
  type        = map(bool)
  default     = {
    retrive_slb_ip    = "true"
    retrive_slb_id    = "false"
    retrive_slb_proto = "true"
  }
}

variable "ssl_certificates" {
  description = "SLB Server certificate settings to use on listeners. It's supports fields 'tls_cipher_policy', 'server_certificate_id' and 'enable_http2'"
  type        = map(string)
  default     = {
    tls_cipher_policy = "tls_cipher_policy_1_0"
  }
}
