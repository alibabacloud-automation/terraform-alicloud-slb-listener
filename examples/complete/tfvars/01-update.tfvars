##############################################################
#variables for alicloud_slb_listener
##############################################################
bandwidth           = "1"
scheduler           = "wlc"
healthy_threshold   = 5
gzip                = true
health_check_type   = "http"

health_check = {
    healthy_threshold         = "5"
    unhealthy_threshold       = "5"
    health_check_timeout      = "10"
    health_check_interval     = "3"
    health_check              = "on"
    health_check_connect_port = "100"
    health_check_uri          = "-"
    health_check_http_code    = "http_2xx,http_3xx"
    health_check_type         = "http"
}

advanced_setting = {
    sticky_session      = "on"
    sticky_session_type = "insert"
    cookie_timeout      = "80000"
    gzip                = "false"
}

x_forwarded_for = {
    retrive_slb_ip    = "true"
    retrive_slb_id    = "true"
    retrive_slb_proto = "true"
}

ssl_certificates = {
  tls_cipher_policy = "tls_cipher_policy_1_1"
}