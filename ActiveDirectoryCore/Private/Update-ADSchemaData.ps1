
function Update-ADSchemaData {
    <#
    .SYNOPSIS
    Updates the cached schema data for value format lookup.

    .DESCRIPTION
    Possibly temporary. Prototyping.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $Path
    )

    $content = Get-Content -Path $Path -Raw
    $matchedAttributes = [Regex]::Matches(
        $content,
        'attributeSyntax: (?<AttributeSyntax>\S+).+?oMSyntax: (?<oMSyntax>\S+).+?lDAPDisplayName: (?<Name>\S+).*?', 'SingleLine'
    )
    $data = @{}
    foreach ($attribute in $matchedAttributes) {
        $data.Add(
            $attribute.Groups['Name'].Value.ToLower(),
            @{
                oMSyntax        = $attribute.Groups['oMSyntax'].Value -as [int]
                attributeSyntax = $attribute.Groups['AttributeSyntax'].Value
            }
        )
    }
    $dataPath = Join-Path -Path $MyInvocation.MyCommand.Module.ModuleBase -ChildPath 'Data\Attributes.json'
    $data | ConvertTo-Json | Set-Content -Path $dataPath

    [ADObject]::AttributeSyntax = $data
}
