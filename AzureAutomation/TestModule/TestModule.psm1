#TestModule.psm

function get-AllResourceGroups {
    Get-AzureRmResourceGroup 
}

function get-VMCount {
    (get-azurermvm).count  
}

function get-RoleCount {
    (Get-AzureRmRoleAssignment).count
}