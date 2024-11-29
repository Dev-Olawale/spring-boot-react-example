resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "main" {
  name                = var.asp_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "S1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "springboot_react_app" {
  name                = var.lwapp_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  site_config {}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_application_insights" "main" {
  name                = var.insight_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "java"
  retention_in_days   = 30
}

resource "null_resource" "application_insights_connection_string" {
  triggers = {
    key = "${azurerm_linux_web_app.springboot_react_app.identity[0].principal_id}:${azurerm_application_insights.main.instrumentation_key}"
  }

  provisioner "local-exec" {
    command = "az webapp config appsettings set --ids ${azurerm_linux_web_app.springboot_react_app.id} --settings APPLICATIONINSIGHTS_INSTRUMENTATION_KEY='${azurerm_application_insights.main.instrumentation_key}' APPLICATIONINSIGHTS_CONNECTION_STRING='${azurerm_application_insights.main.connection_string}' APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL='INFO' ApplicationInsightsAgent_EXTENSION_VERSION='~2' --output none"
  }
}

resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}
