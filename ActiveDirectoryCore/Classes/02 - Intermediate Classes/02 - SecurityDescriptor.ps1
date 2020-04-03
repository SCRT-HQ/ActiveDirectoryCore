class SecurityDescriptor {
    [ushort] $Control
    [SID]    $OwnerSid
    [SID]    $GroupSid
    [Acl]    $Audit
    [Acl]    $Access

    hidden [byte] $revision
    hidden [byte] $sbz1
    hidden [uint] $offsetOwner
    hidden [uint] $offsetGroup
    hidden [uint] $offsetSacl
    hidden [uint] $offsetDacl

    SecurityDescriptor([byte[]] $securityDescriptorBytes) {
        $binaryReader = [System.IO.BinaryReader][System.IO.MemoryStream]$securityDescriptorBytes

        $this.revision = $binaryReader.ReadByte()
        $this.sbz1 = $binaryReader.ReadByte()
        $this.Control = $binaryReader.ReadUInt16()
        $this.offsetOwner = $binaryReader.ReadUInt16()
        $this.offsetGroup = $binaryReader.ReadUInt16()
        $this.offsetSacl = $binaryReader.ReadUInt16()
        $this.offsetDacl = $binaryReader.ReadUInt16()

        $this.Owner = [Sid]::new($binaryReader)
        $this.Group = [Sid]::new($binaryReader)
        $this.Audit = [Acl]::new($binaryReader)
        $this.Dacl = [Acl]::new($binaryReader)
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
        $bytes.AddRange($this.Owner.GetBytes())
        $bytes.AddRange($this.Group.GetBytes())
        $bytes.AddRange($this.Audit.GetBytes())
        $bytes.AddRange($this.Access.GetBytes())

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
