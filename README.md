# Terraform Module: Azure Identity Provider (IdP) Integration
![Firefly Logo](firefly.gif)

This Terraform module automates the configuration of Azure as an Identity Provider (IdP) for seamless Single Sign-On (SSO) integration with your applications and services.

## Features

- Configures Azure AD as an Identity Provider for authentication.
- Assigns users directly to the Azure AD enterprise application.
- Manages Azure application and user group assignments for enhanced access control.

## Prerequisites

Before using this module, ensure that you have the following:

- **Azure Active Directory (AAD)**: An active Azure AD tenant with administrative privileges.
- **Terraform**: Version 1.0 or higher.
- **Random Terraform Provider**: Required for generating unique resource names when applicable.

## Example Usage

### Create Application and Assign Users Directly
```hcl
module "demo-sso-firefly" {
  source = "github.com/gofireflyio/terraform-sso-azure"
  providers = {
    azuread = azuread
    random  = random
  }
  
  domain               = "demo"
  tenant_id            = "00000000-0000-0000-0000-000000000000"
  app_name             = "demo-firefly"
  firefly_users_emails = ["user1@demo.com", "user2@demo.com"]
}
```

### Create Application, and Viewers & Admins Groups
```hcl
module "demo-sso-firefly" {
  source = "github.com/gofireflyio/terraform-sso-azure"
  providers = {
    azuread = azuread
    random  = random
  }

  domain               = "demo"
  tenant_id            = "00000000-0000-0000-0000-000000000000"
  create_admins_group  = true
  create_viewers_group = true
}
```

### Create Application and Use Existing Groups
```hcl
module "demo-sso-firefly" {
  source = "github.com/gofireflyio/terraform-sso-azure"
  providers = {
    azuread = azuread
    random  = random
  }

  domain                        = "demo"
  tenant_id                     = "00000000-0000-0000-0000-000000000000"
  existing_admins_group_name    = "Firefly-Demo-Admins"
}
```

## Variables

The following table outlines the variables available for this module:

| Variable                      | Type          | Required | Description                                                                 | Example Value                          |
|--------------------------------|--------------|----------|-----------------------------------------------------------------------------|----------------------------------------|
| `domain`                      | `string`     | ✅ Yes  | The domain name of the organization. Must match the domain in Azure AD.     | `"demo"`                              |
| `tenant_id`                   | `string`     | ✅ Yes  | The Azure AD tenant ID required for authentication.                         | `"00000000-0000-0000-0000-000000000000"`                    |
| `firefly_users_emails`         | `list(string)` | ❌ No   | List of user email addresses to assign directly to the application.         | `["user1@demo.com", "user2@demo.com"]` |
| `app_name`                    | `string`     | ❌ No   | The display name of the Azure AD enterprise application. Default: "Firefly".| `"demo-Firefly"`                           |
| `create_admins_group`          | `bool`       | ❌ No   | Creates an administrators group if set to `true`.                           | `true`                                 |
| `new_admins_group_name`        | `string`     | ❌ No   | Name of the newly created admin group. Default: "Firefly-Admins".          | `"Demo-Admins"`                     |
| `create_viewers_group`         | `bool`       | ❌ No   | Creates a viewers group if set to `true`.                                   | `true`                                 |
| `new_viewers_group_name`       | `string`     | ❌ No   | Name of the newly created viewers group. Default: "Firefly-Viewers".       | `"Demo-Viewers"`                    |
| `existing_admins_group_name`   | `string`     | ❌ No   | Name of a pre-existing admins group to use instead of creating a new one.   | `"Existing-Demo-Admins"`                   |
| `existing_viewers_group_name`  | `string`     | ❌ No   | Name of a pre-existing viewers group to use instead of creating a new one.  | `"Existing-Demo-Viewers"`                  |

### Notes:
- Ensure that the `domain` matches your organization's Azure AD domain to enable proper authentication.
- The `tenant_id` is required for establishing a connection with Azure AD.
- Users specified in `firefly_users_emails` must already exist in Azure AD before running the Terraform configuration.
- If `create_admins_group` or `create_viewers_group` is set to `true`, the module will create new groups unless `existing_admins_group_name` or `existing_viewers_group_name` is provided.
- To configure SCIM provisioning, please contact the Firefly team for further instructions.



## Outputs

```hcl
output "metadata_url" {
  value = module.demo-sso-firefly.metadata_url
}
```

### Output Explanation
- **`metadata_url`**: This URL provides the SAML metadata required for the configured Azure IdP. 
  - **Action Required:** Share this URL with the Firefly team to complete the integration process.

