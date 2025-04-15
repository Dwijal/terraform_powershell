param(
    [Parameter(Mandatory = $True)] [string] $Environment,
	[Parameter(Mandatory = $True)] [string] $ServicePrincipalSecret,
	[Parameter(Mandatory = $True)] [string] $SharedSubscriptionId,
	[Parameter(Mandatory = $True)] [string] $SharedTenantId,
	[Parameter(Mandatory = $True)] [string] $SharedClientId,
	[Parameter(Mandatory = $True)] [string] $SharedClientSecret,
	[Parameter(Mandatory = $True)] [string] $SharedResourceGroup
)

switch ($Environment) {
	"D" {$envName = "dev"}
	"T" {$envName = "test"}
}

##########################################################
# terraform apply
##########################################################

Write-Host "`n> Applying changes ..." -ForegroundColor Cyan

Set-Location $PSScriptRoot

$azContext = Get-AzContext

$env:ARM_CLIENT_ID = $azContext.Account.Id
$env:ARM_CLIENT_SECRET= $ServicePrincipalSecret
$env:ARM_SUBSCRIPTION_ID = $azContext.Subscription.Id
$env:ARM_TENANT_ID = $azContext.Tenant.Id

$tfstateFile = './envs/' + $envName + '-tfstate-backend.conf'
$varFile = './envs/' + $envName + '.tfvars'
$plan = 'tms-msdk-plan-' + $envName

terraform init --backend-config $tfstateFile -reconfigure

terraform validate

terraform plan -out="$plan" -var-file="$varFile" `
	-var "shared_subscription_id=$SharedSubscriptionId" `
	-var "shared_tenant_id=$SharedTenantId" `
	-var "shared_client_id=$SharedClientId" `
	-var "shared_client_secret=$SharedClientSecret" `
	-var "shared_resource_group=$SharedResourceGroup"