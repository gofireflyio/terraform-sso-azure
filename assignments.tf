// one group for all users
data "azuread_user" "current" {
  for_each            = length(var.firefly_users_emails) > 0 ? toset(var.firefly_users_emails) : toset([])
  user_principal_name = each.value
}

resource "azuread_app_role_assignment" "firefly-users" {
  for_each            = length(var.firefly_users_emails) > 0 ? { for user in data.azuread_user.current : user.id => user } : {}
  app_role_id         = azuread_application.firefly.app_role_ids["User"]
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.firefly-application.object_id
}

// existing groups
data "azuread_group" "existing-admins-group" {
  count            = length(var.existing_admins_group_name) > 0 ? 1 : 0
  display_name     = var.existing_admins_group_name
  security_enabled = true
}

data "azuread_group" "existing-viewers-group" {
  count            = length(var.existing_viewers_group_name) > 0 ? 1 : 0
  display_name     = var.existing_viewers_group_name
  security_enabled = true
}

resource "azuread_app_role_assignment" "firefly-existing-admins-group-assignment" {
  count               = length(var.existing_admins_group_name) > 0 ? 1 : 0
  app_role_id         = azuread_application.firefly.app_role_ids["User"]
  principal_object_id = data.azuread_group.existing-admins-group[count.index].object_id
  resource_object_id  = azuread_service_principal.firefly-application.object_id
}

resource "azuread_app_role_assignment" "firefly-existing-viewers-group-assignment" {
  count               = length(var.existing_viewers_group_name) > 0 ? 1 : 0
  app_role_id         = azuread_application.firefly.app_role_ids["User"]
  principal_object_id = data.azuread_group.existing-viewers-group[count.index].object_id
  resource_object_id  = azuread_service_principal.firefly-application.object_id
}

// new groups
resource "azuread_group" "firefly-admins-group" {
  count            = var.create_admins_group ? 1 : 0
  display_name     = var.new_admins_group_name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group" "firefly-viewers-group" {
  count            = var.create_viewers_group ? 1 : 0
  display_name     = var.new_viewers_group_name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_app_role_assignment" "firefly-new-admins-group-assignment" {
  count               = var.create_admins_group ? 1 : 0
  app_role_id         = azuread_application.firefly.app_role_ids["User"]
  principal_object_id = azuread_group.firefly-admins-group[count.index].object_id
  resource_object_id  = azuread_service_principal.firefly-application.object_id
}

resource "azuread_app_role_assignment" "firefly-new-viewers-group-assignment" {
  count               = var.create_viewers_group ? 1 : 0
  app_role_id         = azuread_application.firefly.app_role_ids["User"]
  principal_object_id = azuread_group.firefly-viewers-group[count.index].object_id
  resource_object_id  = azuread_service_principal.firefly-application.object_id
}