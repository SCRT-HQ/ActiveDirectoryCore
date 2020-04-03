class ADComputer : ADPrincipal {
    hidden static [string[]] $DefaultProperties = [ADPrincipal]::DefaultProperties + @(
        'DNSHostName'
    )

    ADComputer([object] $entry, [string[]] $Properties) : base($entry, $Properties) { }
}
