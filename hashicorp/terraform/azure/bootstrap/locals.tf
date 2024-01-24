locals {
  location_abbr = { "westcentralus" : "wcus", "westus" : "wus", "westus2" : "wus2" }
  uniq_name     = length(regexall("[[:alnum:]]", chomp(trimspace(var.unique_name_string)))) < 1 ? "" : "${var.unique_name_string}-"
  tags = merge({
    "terraform" : "yes",
    "module" : "terraform-azurerm-aks-module"
  }, var.tags)
}
