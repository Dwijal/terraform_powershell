# file: manage-vm.ps1

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start","stop")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$TagName = "Schedule",

    [Parameter(Mandatory=$false)]
    [string]$TagValue = "OfficeHours"
)

Write-Host "Action: $Action"
Write-Host "Filtering VMs with tag $TagName=$TagValue"

# Get all VMs with tag
$vms = Get-AzVM -Status | Where-Object {
    $_.Tags[$TagName] -eq $TagValue
}

if (-not $vms) {
    Write-Host "No VMs found with tag $TagName=$TagValue"
    exit 0
}

foreach ($vm in $vms) {

    $vmName = $vm.Name
    $rgName = $vm.ResourceGroupName
    $status = ($vm.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus

    Write-Host "VM: $vmName | Status: $status"

    if ($Action -eq "start" -and $status -ne "VM running") {
        Write-Host "Starting VM: $vmName"
        Start-AzVM -ResourceGroupName $rgName -Name $vmName -NoWait
    }

    elseif ($Action -eq "stop" -and $status -ne "VM deallocated") {
        Write-Host "Stopping VM: $vmName"
        Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force -NoWait
    }

    else {
        Write-Host "Skipping VM: $vmName (No action needed)"
    }
}
=================================================================================================================================

# azure-pipelines-start.yml

trigger: none

schedules:
- cron: "0 3 * * 1-5"   # 8:30 AM IST
  displayName: Start VMs (Weekdays)
  branches:
    include:
    - main
  always: true

pool:
  vmImage: 'ubuntu-latest'

steps:

- task: AzurePowerShell@5
  inputs:
    azureSubscription: 'YOUR-SERVICE-CONNECTION'
    ScriptType: 'FilePath'
    ScriptPath: './manage-vm.ps1'
    ScriptArguments: '-Action start'
    azurePowerShellVersion: 'LatestVersion'


==================================================================================================================

# azure-pipelines-stop.yml

trigger: none

schedules:
- cron: "0 13 * * 1-5"   # 6:30 PM IST
  displayName: Stop VMs (Weekdays)
  branches:
    include:
    - main
  always: true

pool:
  vmImage: 'ubuntu-latest'

steps:

- task: AzurePowerShell@5
  inputs:
    azureSubscription: 'YOUR-SERVICE-CONNECTION'
    ScriptType: 'FilePath'
    ScriptPath: './manage-vm.ps1'
    ScriptArguments: '-Action stop'
    azurePowerShellVersion: 'LatestVersion'
