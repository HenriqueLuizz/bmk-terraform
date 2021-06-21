resource "oci_core_vcn" "vcn_protheus" {
    #Required
    cidr_block      = "10.0.0.0/16"
    compartment_id  = var.compartment_ocid
    #Optional
    display_name    = "vcn_protheus"
    dns_label       = "vcnprotheus"
}

resource "oci_core_subnet" "subn_privada" {
    #Required
    cidr_block        = "10.0.3.0/24"
    compartment_id    = var.compartment_ocid
    vcn_id            = oci_core_vcn.vcn_protheus.id
    display_name      = "subn_privada"
    dns_label         = "subnprivada"
    prohibit_public_ip_on_vnic = "true"
    route_table_id    = oci_core_route_table.routetable1.id
    security_list_ids = [oci_core_security_list.SecurityListTForm.id]
}

resource "oci_core_subnet" "subn_publica" {
    #Required
    cidr_block        = "10.0.4.0/24"
    compartment_id    = var.compartment_ocid
    vcn_id            = oci_core_vcn.vcn_protheus.id
    display_name      = "subn_publica"
    dns_label         = "subnpublica"
    prohibit_public_ip_on_vnic = "false"
    route_table_id    = oci_core_route_table.routetable1.id
    security_list_ids = [oci_core_security_list.SecurityListTForm.id]
}

resource "oci_core_nat_gateway" "nat_gateway" {
    display_name = "${var.prefix}natgateway"
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn_protheus.id
}

resource "oci_core_internet_gateway" "internetgateway1" {
  compartment_id = var.compartment_ocid
  display_name   = "internetgateway1"
  vcn_id         = oci_core_vcn.vcn_protheus.id
}

resource "oci_core_route_table" "routetable1" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_protheus.id
  display_name   = "routetable1"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.internetgateway1.id
  }
}

resource "oci_core_route_table" "routetable2" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_protheus.id
  display_name   = "${var.prefix}routetable2"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }

  # TODO: Verificar a regiao
  # route_rules {
  #   destination_type  = "SERVICE_CIDR_BLOCK"
  #   destination       = "OCI <REGIAO> Object Storage"
  #   network_entity_id = "ocid1.servicegateway.oc1.iad.aaaaaaaafpzstuelymkuxl4bpyagpmidgasfi3rmyrxusazzodt53x3bdf3a"
  # }
}

#-----------------------------------------------------------------------------------------#

resource "oci_core_security_list" "SecurityListTForm" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_protheus.id
  display_name   = "Security List com Regras TForm"



  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"  # 6
    destination_type = "CIDR_BLOCK"
  }

  #TODO : verificar a região 
  # egress_security_rules {
  #   destination = "All <REGIAO> Services in Oracle Services Network"
  #   protocol    = "all"  # 6
  #   destination_type = "SERVICE_CIDR_BLOCK"
  # }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "all"         // tcp
    source    = "0.0.0.0/0"
    stateless = false
  }
}