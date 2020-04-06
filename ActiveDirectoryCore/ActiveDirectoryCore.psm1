using namespace Novell.Directory.Ldap

$script:ActiveDirectoryCore = [PSCustomObject]@{
    Connection = $null
    DomainDN   = $null
    Credential = $null
    Server     = $null
    Port       = 389
}

# PSM1 Footer
$dataPath = Join-Path -Path $PSScriptRoot -ChildPath 'Data\Attributes.json'
[ADObject]::AttributeSyntax = Get-Content -Path $dataPath -Raw | ConvertFrom-Json -AsHashtable
$ADCore_OnRemoveScript = {
    if ($script:ActiveDirectoryCore.Connection -and $script:ActiveDirectoryCore.Connection.Connected) {
        $script:ActiveDirectoryCore.Connection.Disconnect()
    }
}
$ExecutionContext.SessionState.Module.OnRemove += $ADCore_OnRemoveScript
