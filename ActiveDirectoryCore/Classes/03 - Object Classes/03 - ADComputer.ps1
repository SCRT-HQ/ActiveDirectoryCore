class ADComputer : ADPrincipal {
    hidden static [string[]] $DefaultProperties = [ADPrincipal]::DefaultProperties + @(
        'dnsHostName'
    )

    ADComputer([object] $entry, [string[]] $Properties) : base($entry, $Properties) { }
}
