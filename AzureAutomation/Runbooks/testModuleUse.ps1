<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

#Get all ARM resources from all resource groups
$ResourceGroups = Get-AzureRmResourceGroup 

Import-Module TestModule
"Getting All RGs"
get-AllResourceGroups
"Role Assignment Count"
get-RoleCount
"VMCount"
get-VMCount

start-job -ScriptBlock {"toad"}


#$acctKey = ConvertTo-SecureString -String "luPZp28GdyJRbFI2wkqWExRlfZgEulkETgob1CALQJPblUg8+Pt5lOSRF7ldDSFtc+tBCknHIeIJw0HBqahk4A==" -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\dcbreporting001", $acctKey
$credential Get-AutomationPSCredential -Name "dcbreporting001"
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\dcbreporting001.file.core.windows.net\tempdata" -Credential $credential -Persist
get-psdrive