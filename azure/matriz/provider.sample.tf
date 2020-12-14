provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  # version = "=1.44.0"
  version = "~> 2.1.0"

  features {}

  subscription_id = "123456-123456-123456-123456-123456"
  tenant_id       = "aaaaaa-bbbb-ccccc-dddd-eeeeeee"
}