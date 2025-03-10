output "metadata_url" {
  value = "https://login.microsoftonline.com/${var.tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${azuread_application.firefly.client_id}"
}