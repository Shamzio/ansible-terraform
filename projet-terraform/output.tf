
output "datastore_name" {
  description = "Nom du datastore utilisé"
  value       = data.vsphere_datastore.datastore.name
}


