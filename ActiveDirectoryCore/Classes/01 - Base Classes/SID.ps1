class SID : IEquatable[Object] {
    [int]    $BinaryLength
    [string] $AccountDomainSid
    [string] $Value

    [byte] $revisionLevel
    [IdentifierAuthority] $identifierAuthority
    [uint[]] $subAuthorities

    SID([string] $sidString) {
        $null, $this.RevisionLevel, $this.identifierAuthority, $this.subAuthorities = $sidString -split '-'
        $this.BinaryLength = 8 + ($this.subAuthorities.Count * 4)
        $this.Value = $this.ToString()

        if ($this.subAuthorities.Count -eq 4) {
            $this.AccountDomainSid = $sidString
        }
        elseif ($this.subAuthorities.Count -gt 4) {
            $this.AccountDomainSid = $sidString -replace '-\d+$'
        }
    }

    SID([byte[]] $sidBytes) {
        $this.BinaryLength = $sidBytes.Count

        $this.revisionLevel = $sidBytes[0]
        $subAuthorityCount = $sidBytes[1]

        $identifierAuthorityBytes = [byte[]]::new(8)
        [Array]::Copy(
            $sidBytes,
            2,
            $identifierAuthorityBytes,
            2,
            6
        )
        [Array]::Reverse($identifierAuthorityBytes)
        $this.identifierAuthority = [BitConverter]::ToUInt64($identifierAuthorityBytes)

        $this.subAuthorities = for ($i = 0; $i -lt ($subAuthorityCount * 4); $i += 4) {
            [BitConverter]::ToUInt32([byte[]](
                $sidBytes[$i + 3],
                $sidBytes[$i + 2],
                $sidBytes[$i + 1],
                $sidBytes[$i]
            ))
        }

        $this.Value = $this.ToString()

        if ($this.subAuthorities.Count -eq 4) {
            $this.AccountDomainSid = $this
        }
        elseif ($this.subAuthorities.Count -gt 4) {
            $accountDomainSidBytes = [byte[]]::new($this.BinaryLength - 4)
            [Array]::Copy(
                $sidBytes,
                0,
                $accountDomainSidBytes,
                $accountDomainSidBytes.Count
            )
            $accountDomainSidBytes[1] = $this.subAuthorities.Count - 1
            $this.AccountDomainSid = [Sid]::new($accountDomainSidBytes)
        }
    }

    [byte[]] GetBinaryForm() {
        $sidBytes = [byte[]]::new($this.BinaryLength)
        $sidBytes[0] = $this.revisionLevel
        $sidBytes[1] = $this.subAuthorities.Count

        $identifierAuthorityBytes = [BitConverter]::GetBytes([ulong]$this.identifierAuthority)
        [Array]::Reverse($identifierAuthorityBytes)

        [Array]::Copy(
            $identifierAuthorityBytes,
            2,
            $sidBytes,
            2,
            6
        )

        for ($i = 0; $i -lt $this.subAuthorities.Count; $i++) {
            $subAuthorityBytes = [BitConverter]::GetBytes($this.subAuthorities[$i])
            [Array]::Copy(
                $subAuthorityBytes,
                0,
                $sidBytes,
                (8 + ($i * 4)),
                4
            )
        }

        return $sidBytes
    }

    [string] ToString() {
        return 'S-{0}-{1}-{2}' -f @(
            $this.revisionLevel
            [ulong]$this.identifierAuthority
            $this.subAuthorities -join '-'
        )
    }

    [Boolean] Equals(
        [Object] $object
    ) {
        return $this.ToString() -eq $object.ToString()
    }

    hidden static [System.Security.Principal.SecurityIdentifier] op_Implicit([SID] $sid) {
        return [System.Security.Principal.SecurityIdentifier]$sid.ToString()
    }
}
