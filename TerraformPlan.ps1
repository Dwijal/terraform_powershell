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
	-var "shared_subscription_id=$SubscriptionId" `
	-var "shared_tenant_id=$TenantId" `
	-var "shared_client_id=$ClientId" `
	-var "shared_client_secret=$ClientSecret" `
	-var "shared_resource_group=$ResourceGroup"