class ADUser : ADPrincipal {
    hidden static [string[]] $DefaultProperties = [ADPrincipal]::DefaultProperties + @(
        'GivenName'
        'SN'
        'UserPrincipalName'
    )

    [string] $GivenName
    [string] $Surname
    [string] $UserPrincipalName

    ADUser([object] $entry, [string[]] $Properties) : base($entry, $Properties) { }
}
