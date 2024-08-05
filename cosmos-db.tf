resource "azurerm_resource_group" "exscelesior_rg" {
  name     = "exscelesior-resource-group"
  location = "East US"
}

resource "azurerm_cosmosdb_account" "exscelesior_account" {
  name                = "exscelesior-cosmosdb-account"
  location            = azurerm_resource_group.exscelesior_rg.location
  resource_group_name = azurerm_resource_group.exscelesior_rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = azurerm_resource_group.exscelesior_rg.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"  // Use other capabilities based on your requirements
  }
}

resource "azurerm_cosmosdb_sql_database" "exscelesior_db" {
  name                = "exscelesior-sql-database"
  resource_group_name = azurerm_resource_group.exscelesior_rg.name
  account_name        = azurerm_cosmosdb_account.exscelesior_account.name
}

resource "azurerm_cosmosdb_sql_container" "exscelesior_container" {
  name                = "exscelesior-sql-container"
  resource_group_name = azurerm_resource_group.exscelesior_rg.name
  account_name        = azurerm_cosmosdb_account.exscelesior_account.name
  database_name       = azurerm_cosmosdb_sql_database.exscelesior_db.name
  partition_key_path  = "/partitionKey"

}