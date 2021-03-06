﻿Get-Module mtr.ADE | Remove-Module
Import-Module mtr.ADE

$RoleGroup = 'Routing Services'
$Credential = Get-Credential -Message 'Enter administrative credentials, required to install AD Service Account on target host(s)'
$SvcAccountInfo = (Import-PowerShellDataFile -Path 'F:\DFS\DscRepo\Documents\_ConfigurationData\EnvironmentConfiguration.psd1').ServiceAccounts
$SvcAccountInfo  = ($SvcAccountInfo | ? {($_.RoleGroup -eq $RoleGroup -or $_.RoleAlias -eq $RoleGroup)})

foreach($info in $SvcAccountInfo){
    foreach ($id in $Info.Identities){
        if($id.AccountType -eq 'gMSA'){
            foreach($role in $id.Role){
                $Computers = (Get-AdComputer -Filter "name -like '*-$role-*'").Name
                Install-ManagedServiceAccount -ComputerName $Computers -Identity "$($id.Name)$" -Credential $Credential
            } 
        }
    }
}