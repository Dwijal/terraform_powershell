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
####################################################################################################################################
START ALL THE VM

$vms = Get-AzVM -ResourceGroupName "rg1"

foreach ($vm in $vms) {
    Start-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName
}
####################################################################################################################################
TAG ALL THE VM
$vms = Get-AzVM

foreach ($vm in $vms) {
    $vm.Tags["env"] = "prod"
    Update-AzVM -ResourceGroupName $vm.ResourceGroupName -VM $vm
}
####################################################################################################################################
GET VM IN SPCEIFIC REGION
Get-AzVM | Where-Object { $_.Location -eq "CentralIndia" }
