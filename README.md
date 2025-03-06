# Terraform Module: Azure Identity Provider (IdP) Integration

This Terraform module automates the setup of Azure as an Identity Provider (IdP) for seamless Single Sign-On (SSO) integration with your applications and services.

## Features

- Configures Azure as an IdP for authentication.
- Assigns users to the Azure IdP.
- Manages Azure application and user assignments.

## Prerequisites

- **Azure Active Directory (AAD)**: An active Azure AD tenant with administrative privileges.
- **Terraform**: Version 1.0 or higher.
- **Azure Terraform Provider**: Properly configured with the necessary credentials.
- **Random Terraform Provider**

## Usage

Below is an example of how to use this module in your Terraform configuration:

```hcl
module "firefly-demo" {
  source = "github.com/gofireflyio/terraform-sso-azure"

  providers = {
    azuread = azuread
    random  = random
  }

  domain     = "demo"
  user_email = ["user1@demo.com", "user2@demo.com"]
}
```
## Variables Explanation

| Variable   | Type          | Description                                                                                  | Example Value                  |
|------------|--------------|----------------------------------------------------------------------------------------------|--------------------------------|
| `domain`   | `string`      | The domain name of the company. This should match the domain configured in Azure AD.       | `"demo"`                |
| `user_emails` | `list(string)` | A list of email addresses for users that will be assigned to the application in Azure.   | `["user1@demo.com", "user2@demo.com"]` |

### Notes:
- **`domain`**: Ensure this matches your organization's Azure AD domain for proper authentication.
- **`user_email`**: All users in this list must exist in Azure AD before applying the Terraform configuration.
- Currently, this module does not create a group containing all the provided users and assign it to the application. Instead, each user is assigned individually.
