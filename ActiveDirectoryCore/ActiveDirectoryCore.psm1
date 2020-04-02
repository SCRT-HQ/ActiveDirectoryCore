using namespace Novell.Directory.Ldap

Add-Type -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Novell.Directory.Ldap.NETStandard.dll') -ErrorAction SilentlyContinue

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
