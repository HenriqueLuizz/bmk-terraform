##
## TFORM - VMs Secundarias 
## Define o numero de VMs através da variável INSTANCES.
##

resource "oci_core_instance" "xgh_tec" {
  availability_domain = var.OCI_AD["AD1"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-VM-xgh-tec"

  shape               = "VM.Standard.A1.Flex"
  shape_config {
    ocpus = 2
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id           = var.subn_publica
    assign_public_ip    = "true"
    display_name        = "${var.prefix}vnicxghtec"
    hostname_label      = "${var.prefix}vmxghtec"
    private_ip          = cidrhost("10.0.4.0/24", 200)
  }

  source_details {
    source_id=var.source_id["ARM"]
    boot_volume_size_in_gbs=128
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

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/.wgetrc"
    destination="/tmp/.wgetrc"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/provisioner/start_protheus-sec.sh"
    destination="/tmp/start_protheus-sec.sh"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/totvs_lnx/protheus_bundle_x64-12.1.33-lnx-sec.zip"
    destination="/tmp/protheus_bundle_x64-12.1.33-lnx-sec.zip"
  }

  provisioner "remote-exec" {
    inline = ["sudo firewall-cmd --permanent --zone=public --add-service=http",
    "sudo firewall-cmd --reload",
    "sudo firewall-cmd --state",
    "sudo systemctl stop firewalld",
    "sudo systemctl disable firewalld",
    "echo '1 - provisioner computer $$(pwd)' | sudo tee -a /tmp/timeline.txt"
    ]
  }
}

resource "oci_core_volume" "xgh_tec_block0" {
  availability_domain = var.OCI_AD["AD1"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-vol-xgh-tec"
  size_in_gbs         = "128"
}

# Conecta secondary_block0
resource "oci_core_volume_attachment" "xgh_tec_block0Attach" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.xgh_tec.id
  volume_id       = oci_core_volume.xgh_tec_block0.id

  connection {
    type          = "ssh"
    host          = oci_core_instance.xgh_tec.public_ip
    user          = "opc"
    private_key   = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /totvs",
      "sudo mkfs.xfs /dev/sdb",
      "sudo mount -t xfs /dev/sdb /totvs",
      "echo '/dev/sdb /totvs xfs defaults,_netdev,nofail 0 2' | sudo tee -a /etc/fstab",
      "echo '2 - attachment disk $(pwd)' | sudo tee -a /tmp/timeline.txt",
      "cp /tmp/.wgetrc ~/.wgetrc",
      "/bin/bash /tmp/start_protheus-sec.sh"
    ]
  }
}
