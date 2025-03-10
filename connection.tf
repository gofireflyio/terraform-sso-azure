data "azuread_client_config" "current" {}

resource "random_uuid" "role" {}

resource "azuread_application" "firefly" {
  display_name            = var.app_name
  logo_image              = filebase64("${path.module}/utility/logo.png")
  owners                  = [data.azuread_client_config.current.object_id]
  identifier_uris         = ["${local.identifier_uri}-${var.domain}"]
  sign_in_audience        = "AzureADMyOrg"
  prevent_duplicate_names = true

  web {
    redirect_uris = ["${local.reply_url}-${var.domain}"]
  }

  group_membership_claims = length(var.firefly_users_emails) == 0 ? ["ApplicationGroup"] : []

  optional_claims {
    saml2_token {
      name                  = "groups"
      additional_properties = length(var.firefly_users_emails) == 0 ? ["cloud_displayname"] : []
    }
  }

  feature_tags {
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true
  }

  app_role {
    allowed_member_types = ["User"]
    display_name         = "User"
    description          = "Firefly user role"
    enabled              = true
    id                   = random_uuid.role.id
    value                = "User"
  }
}

resource "azuread_service_principal" "firefly-application" {
  client_id                     = azuread_application.firefly.client_id
  use_existing                  = true
  preferred_single_sign_on_mode = "saml"

  feature_tags {
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true
  }
}

// adds a certificate to the enterprise app
resource "azuread_service_principal_token_signing_certificate" "firefly" {
  service_principal_id = azuread_service_principal.firefly-application.id
}