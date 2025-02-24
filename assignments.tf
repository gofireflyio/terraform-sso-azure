data "azuread_user" "current" {
  for_each            = toset(var.user_email)
  user_principal_name = each.value
}

resource "azuread_app_role_assignment" "firefly-users" {
  for_each            = { for user in data.azuread_user.current : user.id => user }
  app_role_id         = random_uuid.role.id
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.firefly-application.object_id
}