provider "azurerm" {
  features {}
  subscription_id = "261ca972-c53b-44e5-ba3f-7fd53782da37"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-academia-novo"
  location = "East US"
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-academia"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "F1"
  os_type  = "Windows"
}

resource "azurerm_windows_web_app" "app" {
  name                = "webapp-academia-${random_integer.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false  # <- Isso resolve o problema
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }

  depends_on = [random_integer.suffix]
}
