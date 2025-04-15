param(
    [Parameter(Mandatory = $True)] [string] $Environment,
	[Parameter(Mandatory = $True)] [string] $SubscriptionId,
	[Parameter(Mandatory = $True)] [string] $TenantId,
	[Parameter(Mandatory = $True)] [string] $ClientId,
	[Parameter(Mandatory = $True)] [string] $ClientSecret,
	[Parameter(Mandatory = $True)] [string] $ResourceGroup
)

switch ($Environment) {
	"D" {$envName = "dev"}
	"T" {$envName = "test"}
}

##########################################################
# terraform apply
##########################################################

Write-Host "`n> Applying changes ..." -ForegroundColor Cyan




$tfstateFile = './envs/' + $envName + '-tfstate-backend.conf'
$varFile = './envs/' + $envName + '.tfvars'
$plan = 'tms-msdk-plan-' + $envName

terraform init --backend-config $tfstateFile -reconfigure

terraform validate

terraform plan -out="$plan" -var-file="$varFile" `
	-var "subscription_id=$SubscriptionId" `
	-var "tenant_id=$TenantId" `
	-var "client_id=$ClientId" `
	-var "client_secret=$ClientSecret" `
	-var "resource_group=$ResourceGroup"