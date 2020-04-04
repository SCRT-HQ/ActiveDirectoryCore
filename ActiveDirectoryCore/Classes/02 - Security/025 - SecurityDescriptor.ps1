class SecurityDescriptor {
    [SecurityPrincipal] $Owner
    [SecurityPrincipal] $Group
    [Ace[]]             $Audit
    [Ace[]]             $Access
    [bool]              $AreAccessRulesProtected
    [bool]              $AreAuditRulesProtected

    hidden [DSSDControl] $control
    hidden [byte]        $revision
    hidden [byte]        $sbz1
    hidden [uint]        $offsetOwner
    hidden [uint]        $offsetGroup
    hidden [uint]        $offsetSacl
    hidden [uint]        $offsetDacl
    hidden [Acl]         $dacl
    hidden [Acl]         $sacl

    SecurityDescriptor([byte[]] $securityDescriptorBytes) {
        $binaryReader = [EndianBinaryReader][System.IO.MemoryStream]$securityDescriptorBytes

        $this.revision = $binaryReader.ReadByte()
        $this.sbz1 = $binaryReader.ReadByte()
        $this.control = $binaryReader.ReadUInt16($true)
        $this.offsetOwner = $binaryReader.ReadUInt32()
        $this.offsetGroup = $binaryReader.ReadUInt32()
        $this.offsetSacl = $binaryReader.ReadUInt32()
        $this.offsetDacl = $binaryReader.ReadUInt32()

        $this.AreAccessRulesProtected = $this.control.HasFlag([DSSDControl]::DaclProtected)
        $this.AreAuditRulesProtected = $this.control.HasFlag([DSSDControl]::SaclProtected)

        if ($this.offsetOwner -gt 0) {
            $binaryReader.BaseStream.Seek($this.offsetOwner, 'Begin')
            $this.Owner = [Sid]::new($binaryReader)
        }
        if ($this.offsetGroup -gt 0) {
            $binaryReader.BaseStream.Seek($this.offsetGroup, 'Begin')
            $this.Group = [Sid]::new($binaryReader)
        }
        if ($this.offsetSacl) {
            $binaryReader.BaseStream.Seek($this.offsetSacl, 'Begin')
            $this.sacl = [Acl]::new($binaryReader)
            $this.Audit = $this.sacl.Ace
        }
        if ($this.offsetDacl) {
            $binaryReader.BaseStream.Seek($this.offsetDacl, 'Begin')
            $this.dacl = [Acl]::new($binaryReader)
            $this.Access = $this.dacl.Ace
        }
    }

    [byte[]] GetBytes() {
        $bytes = [System.Collections.Generic.List[byte]]::new()
        $bytes.Add($this.revision)
        $bytes.Add($this.sbz1)
        $bytes.AddRange([BitConverter]::GetBytes($this.Control))
        $bytes.AddRange([BitConverter]::GetBytes($this.offsetOwner))
        $bytes.AddRange([BitConverter]::GetBytes($this.offsetGroup))
        $bytes.AddRange([BitConverter]::GetBytes($this.offsetSacl))
        $bytes.AddRange([BitConverter]::GetBytes($this.offsetDacl))
        # $bytes.AddRange($this.Owner.GetBytes())
        # $bytes.AddRange($this.Group.GetBytes())
        # $bytes.AddRange($this.saclMetadata.GetBytes())
        # $bytes.AddRange($this.daclMetadata.GetBytes())

        return $bytes.ToArray()
    }

    hidden static [System.DirectoryServices.ActiveDirectorySecurity] op_Implicit([SecurityDescriptor] $securityDescriptor) {
        try {
            $securityDescriptor = [System.DirectoryServices.ActiveDirectorySecurity]::new()
            # Fill this in.
            return $securityDescriptor
        } catch {
            throw
        }
    }
}
