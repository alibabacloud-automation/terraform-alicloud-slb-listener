#alicloud_slb_acl and alicloud_slb_server_certificate
name = "update-tf-testacc-name"

#ECS
system_disk_size = 60

# Load Balancer Instance attachment
port   = 90
weight = 20

# Listener common variables
bandwidth = 10
scheduler = "rr"

# Health Check
health_check              = "on"
healthy_threshold         = 8
unhealthy_threshold       = 8
health_check_timeout      = 8
health_check_interval     = 5
health_check_connect_port = 20
health_check_domain       = "alibaba.com"
health_check_uri          = "/update_cons"
health_check_http_code    = "http_3xx"
health_check_type         = "http"
health_check_method       = "get"

# Advance setting
sticky_session      = "off"
sticky_session_type = "server"
cookie              = "updatetest"
cookie_timeout      = 86400
gzip                = false
persistence_timeout = 3600
established_timeout = 600
acl_status          = "off"
acl_type            = "black"
idle_timeout        = 30
request_timeout     = 80

# x_forwarded_for setting
retrive_slb_ip    = false
retrive_slb_id    = false
retrive_slb_proto = false

# Ssl certificate setting
tls_cipher_policy = "tls_cipher_policy_1_2"
enable_http2      = "off"