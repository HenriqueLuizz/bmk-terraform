# resource "oci_bastion_bastion" "bmk_bastion" {
#     #Required
#     bastion_type = "standard"
#     compartment_id = var.compartment_ocid
#     target_subnet_id = var.subn_privada

#     client_cidr_block_allow_list = ["191.17.194.242/34"]

#     max_session_ttl_in_seconds = "10800"
#     name = "Allow-Secundary"
#     # static_jump_host_ip_addresses = var.bastion_static_jump_host_ip_addresses
# }

# resource "oci_bastion_session" "bmk_session" {
#     bastion_id = oci_bastion_bastion.bmk_bastion.id
#     key_details {
#         public_key_content = file(var.ssh_file_public_key)
#     }
#     target_resource_details {
#         session_type = var.session_target_resource_details_session_type
#         target_resource_id = oci_bastion_target_resource.test_target_resource.id

#         #Optional
#         target_resource_operating_system_user_name = oci_identity_user.test_user.name
#         target_resource_port = var.session_target_resource_details_target_resource_port
#         target_resource_private_ip_address = var.session_target_resource_details_target_resource_private_ip_address
#     }

#     #Optional
#     display_name = var.session_display_name
#     key_type = var.session_key_type
#     session_ttl_in_seconds = var.session_session_ttl_in_seconds
# }