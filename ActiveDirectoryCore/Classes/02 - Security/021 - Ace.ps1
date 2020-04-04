class Ace {
    [AceType]                                        $AceType
    [System.DirectoryServices.ActiveDirectoryRights] $ActiveDirectoryRights
    [SecurityPrincipal]                              $IdentityReference
    [System.Security.AccessControl.InheritanceFlags] $InheritanceFlags
    [bool]                                           $IsInherited
    [System.Security.AccessControl.PropagationFlags] $PropagationFlags

    hidden [AceFlags] $aceFlags
    hidden [int]      $accessMask
    hidden [ushort]   $aceSize
    hidden [byte[]]   $otherData

    hidden Ace(
        [AceType]            $aceType,
        [AceFlags]           $aceFlags,
        [ushort]             $aceSize,
        [EndianBinaryReader] $binaryReader
    ) {
        $this.AceType = $aceType
        $this.aceFlags = $aceFlags
        $this.aceSize = $aceSize
        $this.accessMask = $binaryReader.ReadUInt32()
        $this.ActiveDirectoryRights = $this.accessMask
        $this.InheritanceFlags = $this.aceFlags -band 0x03
        $this.IsInherited = $this.aceFlags.HasFlag([AceFlags]::Inherited)
        $this.PropagationFlags = ($this.aceFlags -band 0x0C) -as [int] -shr 2

        $this.ReadAce($binaryReader)
    }

    hidden [void] ReadAce([EndianBinaryReader] $binaryReader) {
        $this.IdentityReference = [Sid]::new($binaryReader)
        $remainingSize = $this.aceSize - 8 - $this.IdentityReference.BinaryLength

        if ($remainingSize -gt 0) {
            $this.otherData = $binaryReader.ReadBytes($remainingSize)
        }
    }

    hidden static [Ace] Parse([EndianBinaryReader] $binaryReader) {
        $type = $binaryReader.ReadByte()
        $flags = $binaryReader.ReadByte()
        $size = $binaryReader.ReadUInt16()

        $aceObjectType = switch ([AceType]$type) {
            ([AceType]::AllowObject)   { [ObjectAce] }
            ([AceType]::DenyObject)    { [ObjectAce] }
            ([AceType]::AuditObject)   { [AuditObjectAce] }
            default                    { [Ace] }
        }
        return $aceObjectType::new($type, $flags, $size, $binaryReader)
    }

    [byte[]] GetBytes() {
        $bytes = [System.Collections.Generic.List[byte]]::new()
        $bytes.Add($this.Type)
        $bytes.Add($this.Flags)
        $bytes.AddRange([BitConverter]::GetBytes($this.AccessRights))

        foreach ($sid in $this.Sid) {
            $bytes.AddRange($sid.GetBytes())
        }

        return $bytes.ToArray()
    }
}
