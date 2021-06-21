resource "oci_core_instance" "primary" {
  availability_domain = var.OCI_AD["AD1"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-VM-Primary"
  shape               = var.shape_primary

  shape_config {
    ocpus = var.instance_ocpus
    memory_in_gbs = var.instance_memory
  }

  create_vnic_details {
    subnet_id           = oci_core_subnet.subn_publica.id
    assign_public_ip    = "true"
    display_name        = "${var.prefix}vnicprim"
    hostname_label      = "${var.prefix}vmprim"
    private_ip          = cidrhost("10.0.4.0/24", 10)
    # defined_tags         = {"TOTVS.COMP_TOTVS": "PRIMARY"}
  }

  source_details {
    source_id=var.source_id["X86_64"]
    boot_volume_size_in_gbs=256
    source_type="image"
  }

  metadata = { 
    ssh_authorized_keys = file(var.ssh_file_public_key)
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "opc"
    private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = ["mkdir /tmp/initd"]
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/.wgetrc"
    destination="/tmp/.wgetrc"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/provisioner/start_protheus.sh"
    destination="/tmp/start_protheus.sh"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/totvs_lnx/protheus_bundle_x64-12.1.27-lnx-top-bra.zip"
    destination="/tmp/protheus_bundle_x64-12.1.33-lnx.top-bra.zip"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/totvslicenseserver.sh"
    destination="/tmp/initd/totvslicenseserver.sh"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/totvsdbaccess.sh"
    destination="/tmp/initd/totvsdbaccess.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo firewall-cmd --permanent --zone=public --add-service=http",
    "sudo firewall-cmd --reload",
    "sudo firewall-cmd --state",
    "sudo systemctl stop firewalld",
    "sudo systemctl disable firewalld",
    "echo '1 - provisioner computer $(pwd)' | sudo tee -a /tmp/timeline.txt"
    ]
  }
}