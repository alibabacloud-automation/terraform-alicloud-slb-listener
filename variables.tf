variable "region" {
  description = "(Deprecated from version 1.3.0)The region used to launch this module resources."
  type        = string
  default     = ""
}

variable "profile" {
  description = "(Deprecated from version 1.3.0)The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}

variable "shared_credentials_file" {
  description = "(Deprecated from version 1.3.0)This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}

variable "skip_region_validation" {
  description = "(Deprecated from version 1.3.0)Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

# Load Balancer Instance variables
variable "slb" {
  description = "The load balancer ID used to add one or more listeners."
  type        = string
  default     = ""
}

# Listener common variables
variable "create" {
  description = "Whether to create load balancer listeners."
  type        = bool
  default     = true
}

variable "listeners" {
  description = "List of slb listeners. Each item can set all or part fields of alicloud_slb_listener resource."
  type        = list(map(string))
  default     = []
}

variable "health_check" {
  description = "The slb listener health check settings to use on listeners. It's supports fields 'healthy_threshold','unhealthy_threshold','health_check_timeout', 'health_check', 'health_check_type', 'health_check_connect_port', 'health_check_domain', 'health_check_uri', 'health_check_http_code', 'health_check_method' and 'health_check_interval'"
  type        = map(string)
  default     = {}
}

variable "advanced_setting" {
  description = "The slb listener advanced settings to use on listeners. It's supports fields 'sticky_session', 'sticky_session_type', 'cookie', 'cookie_timeout', 'gzip', 'persistence_timeout', 'acl_status', 'acl_type', 'acl_id', 'idle_timeout' and 'request_timeout'."
  type        = map(string)
  default     = {}
}

variable "x_forwarded_for" {
  description = "Additional HTTP Header field 'X-Forwarded-For' to use on listeners. It's supports fields 'retrive_slb_ip', 'retrive_slb_id' and 'retrive_slb_proto'"
  type        = map(bool)
  default     = {}
}

variable "ssl_certificates" {
  description = "SLB Server certificate settings to use on listeners. It's supports fields 'tls_cipher_policy', 'server_certificate_id' and 'enable_http2'"
  type        = map(string)
  default     = {}
}

# Deprecated variables
variable "healthy_threshold" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'health_check' instead."
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'health_check' instead."
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'health_check' instead."
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'health_check' instead."
  type        = number
  default     = 2
}

variable "enable_sticky_session" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = bool
  default     = false
}

variable "sticky_session_type" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = "server"
}

variable "cookie" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = ""
}

variable "cookie_timeout" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = number
  default     = 86400
}

variable "enable_health_check" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = bool
  default     = false
}

variable "enable_gzip" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = bool
  default     = false
}

variable "retrive_slb_ip" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = bool
  default     = false
}

variable "retrive_slb_id" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = bool
  default     = false
}

variable "retrive_slb_proto" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = bool
  default     = false
}

variable "health_check_connect_port" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = ""
}

variable "health_check_domain" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = ""
}

variable "health_check_uri" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = ""
}

variable "health_check_http_code" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = "http_2xx"
}

variable "health_check_type" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = string
  default     = "tcp"
}

variable "persistence_timeout" {
  description = "(Deprecated) It has been deprecated from 1.2.0, use 'listeners' and 'advance_setting' instead."
  type        = number
  default     = 0
}