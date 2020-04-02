class ADUser : ADPrincipal {
    hidden static [string[]] $DefaultProperties = [ADPrincipal]::DefaultProperties + @(
        'userPrincipalName'
    )

    [string] $UserPrincipalName

    ADUser([object] $entry, [string[]] $Properties) : base($entry, $Properties) { }
}
