# Variables
$resourceGroup = "my-rg"

# List of VMs
$vmNames = @(
    "vm1",
    "vm2",
    "vm3",
    "vm4",
    "vm5"
)

# List of Managed Identity Resource IDs
$identityIds = @(
    "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1",
    "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity2"
)

# Loop through each VM
foreach ($vmName in $vmNames) {

    Write-Host "Processing VM: $vmName"

    # Get VM object
    $vm = Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName

    # Ensure identity type is enabled
    $vm.Identity.Type = "SystemAssigned, UserAssigned"

    # Initialize if empty
    if (-not $vm.Identity.UserAssignedIdentities) {
        $vm.Identity.UserAssignedIdentities = @{}
    }

    # Attach all identities
    foreach ($id in $identityIds) {
        $vm.Identity.UserAssignedIdentities[$id] = @{}
    }

    # Update VM
    Update-AzVM -ResourceGroupName $resourceGroup -VM $vm

    Write-Host "Updated VM: $vmName"
}
