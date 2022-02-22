// Output the ID of the slb and new slb listener created
output "this_slb_id" {
  description = "The ID of the load balancer"
  value       = concat(alicloud_slb_listener.this.*.load_balancer_id, [""])[0]
}

output "this_slb_listener_ids" {
  description = "The id of slb listeners"
  value       = concat(alicloud_slb_listener.this.*.id, [""])[0]
}