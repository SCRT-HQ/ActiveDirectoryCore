class WellKnownPrincipal : SecurityPrincipal {
    [string] $Domain
    [string] $Name
    [Sid]    $Sid

    WellKnownPrincipal([string]$Identity) {
        $this.Domain, $this.Name = $Identity -split '\\'

        $value = [WellKnownPrincipal]::SELF
        if ([Enum]::TryParse([WellKnownPrincipal], $this.Name -replace '[\s-]', [ref]$value)) {
        }
    }

    WellKnownPrincipal([Sid]$sid) {
        $this.Sid = $sid

        if ($sid.IdentifierAuthority -eq 'World' -and $sid.subAuthorities[0] -eq 0) {
            $this.Name = 'Everyone'
        }
        elseif ($sid.IdentifierAuthority -eq 'NT') {
            $this.Domain = switch ($sid.subAuthorities[0]) {
                { $_ -le 20 } { 'NT AUTHORITY'; break }
                32 {
                    if ($Sid.subAuthorities[1] -ge 500 -and $Sid.subAuthorities[1] -lt 600) {
                        'BUILTIN'
                    }
                    break
                }
                80 { 'NT SERVICE'; break }
            }

            $wellKnownSid = ([ulong]$sid.subAuthorities[0] -shl 32) + $sid.subAuthorities[1]

            if ($sidName = [Enum]::GetName([WellKnownSid], $wellKnownSid)) {
                $this.Name = $sidName -creplace '(?<=.)([A-Z])', ' $1'
            }

            $this.Name = switch ($this.Name) {
                'PreWindows 2000 Compatible Access' { 'Pre-Windows 2000 Compatible Access' }
                'HyperV Administrators'             { 'Hyper-V Administrators' }
                default                             { $_ }
            }
        }
    }

    # WellKnownSid($sidType, $domainSid) {

    # }

    # [Sid] GetDomainSid() {
    # }

    # [Sid] GetForestSid() {
    # }

    [string] ToString() {
        if ($this.Domain) {
            return '{0}\{1}' -f $this.Domain, $this.Name
        }
        else {
            return $this.Name
        }
    }
}

[WellKnownPrincipal][Sid]'S-1-5-32-580'
