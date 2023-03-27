data "azurerm_resource_group" "data-project-rg" {
    name = var.main_resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks-airflow" {
    name = "${var.project_name}"
    location = data.azurerm_resource_group.data-project-rg.location
    resource_group_name = data.azurerm_resource_group.data-project-rg.name
    dns_prefix = var.project_name

    default_node_pool {
    name       = var.node_pool_name
    vm_size    = var.aks_vm_size
    enable_auto_scaling = true
    node_count = 2
    min_count = 1
    max_count = 3
    }

    auto_scaler_profile {
        max_unready_nodes = 1
    }

    image_cleaner_enabled = true
    image_cleaner_interval_hours = 72

    automatic_channel_upgrade = var.aks_upgrades_channel

    api_server_access_profile {
        authorized_ip_ranges = var.aks_authorized_ip_ranges
    }
    
    service_principal {
        client_id = var.client_id
        client_secret = var.client_secret
    }

    network_profile {
        network_plugin = "azure"
        network_policy = "azure"
    }
}
