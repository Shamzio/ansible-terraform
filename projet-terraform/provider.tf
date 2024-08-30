provider "vsphere" {
  user                 = "C1-gr7@vsphere.local"
  password             = "C1-gr7!123456"
  vsphere_server       = "172.16.200.212"
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_host" "host" {
  name          = "172.16.103.246"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Définir le resource pool en utilisant le chemin d'accès
data "vsphere_resource_pool" "pool" {
  name          = "/Datacenter/host/172.16.103.246/Resources/Formateurs/Abderaman" 
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "data01ssd1.75"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "WAN-(Internet)"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Créer une VM en utilisant l'hôte ESXi
# Créer une VM sans template
resource "vsphere_virtual_machine" "vm" {
  name             = "MCRTEST"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = "otherGuest" # Utiliser le bon guest_id pour votre système d'exploitation cible

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3" # Spécifiez le type d'adaptateur réseau
  }

  disk {
    label            = "disk0"
    size             = 20   # Taille du disque en GB
    eagerly_scrub    = false
    thin_provisioned = true
  }

  # Optionnel : configuration d'amorçage ou provisionnement
  # Si vous avez un ISO de démarrage ou un script de provisionnement, vous pouvez ajouter ici

}
 
