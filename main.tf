

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.13.0"
    }
  }
}
#vwR8Q~-rjedn.qDOrntNOLEvt._K~2YQPY-RAcbG
provider "azurerm" {
  # Configuration options

  features {
    #This block is must , complusary.
  }
  #Using service principal authentication.

 

}


resource "azurerm_resource_group" "example" {
  name     = "dev"
  location = "West Europe"
}

