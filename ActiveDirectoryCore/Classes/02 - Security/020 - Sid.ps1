class Sid : IEquatable[Object] {
    [int]    $BinaryLength
    [string] $AccountDomainSid
    [string] $Value

    hidden [byte]                $revisionLevel
    hidden [IdentifierAuthority] $identifierAuthority
    hidden [uint[]]              $subAuthorities

    # Create an instance of Sid from a string
    Sid([string] $SidString) {
        $this.ConvertFromString($SidString)
    }

    # Create an instance of Sid from the SecurityIdentifier class
    Sid([System.Security.Principal.SecurityIdentifier]$securityIdentifier) {
        $this.ConvertFromString($securityIdentifier.ToString())
    }

    Sid([byte[]] $SidBytes) {
        $this.ConvertFromByte([EndianBinaryReader][System.IO.MemoryStream]$SidBytes)
    }

    Sid([EndianBinaryReader] $binaryReader) {
        $this.ConvertFromByte($binaryReader)
    }

    hidden [void] ConvertFromByte([EndianBinaryReader] $binaryReader) {
        $this.revisionLevel = $binaryReader.ReadByte()
        $subAuthorityCount = $binaryReader.ReadByte()

        $identifierAuthorityBytes = [byte[]]::new(8)
        [Array]::Copy(
            $binaryReader.ReadBytes(6),
            0,
            $identifierAuthorityBytes,
            2,
            6
        )
        [Array]::Reverse($identifierAuthorityBytes)
        $this.identifierAuthority = [BitConverter]::ToUInt64($identifierAuthorityBytes)

        $this.BinaryLength = 8 + ($subAuthorityCount * 4)
        $this.subAuthorities = for ($i = 0; $i -lt $subAuthorityCount; $i++) {
            [BitConverter]::ToUInt32($binaryReader.ReadBytes(4))
        }

        $this.Value = $this.ToString()

        if ($this.subAuthorities.Count -eq 4) {
            $this.AccountDomainSid = $this
        }
        elseif ($this.subAuthorities.Count -gt 4) {
            $this.AccountDomainSid = [Sid]::new($this.Value -replace '-\d+$')
        }
    }

    hidden ConvertFromString([string] $SidString) {
        $null, $this.RevisionLevel, $this.identifierAuthority, $this.subAuthorities = $SidString -split '-'
        $this.BinaryLength = 8 + ($this.subAuthorities.Count * 4)
        $this.Value = $this.ToString()

        if ($this.subAuthorities.Count -eq 4) {
            $this.AccountDomainSid = $SidString
        }
        elseif ($this.subAuthorities.Count -gt 4) {
            $this.AccountDomainSid = $SidString -replace '-\d+$'
        }
    }

    # Return the security identifier as a byte array.
    [byte[]] GetBytes() {
        $SidBytes = [byte[]]::new($this.BinaryLength)
        $SidBytes[0] = $this.revisionLevel
        $SidBytes[1] = $this.subAuthorities.Count

        $identifierAuthorityBytes = [BitConverter]::GetBytes([ulong]$this.identifierAuthority)
        [Array]::Reverse($identifierAuthorityBytes)

        [Array]::Copy(
            $identifierAuthorityBytes,
            2,
            $SidBytes,
            2,
            6
        )

        for ($i = 0; $i -lt $this.subAuthorities.Count; $i++) {
            $subAuthorityBytes = [BitConverter]::GetBytes($this.subAuthorities[$i])
            [Array]::Copy(
                $subAuthorityBytes,
                0,
                $SidBytes,
                (8 + ($i * 4)),
                4
            )
        }

        return $SidBytes
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

    hidden static [System.Security.Principal.SecurityIdentifier] op_Implicit([Sid] $Sid) {
        return [System.Security.Principal.SecurityIdentifier]$Sid.ToString()
    }
}
