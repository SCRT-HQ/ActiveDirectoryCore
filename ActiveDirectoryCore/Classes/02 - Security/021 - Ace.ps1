class Ace {
    [AceType]  $AceType
    [AceFlags] $AceFlags
    [int]      $AccessMask
    [Sid]      $IdentityReference

    hidden [ushort] $aceSize
    hidden [byte[]] $otherData

    hidden Ace(
        [AceType]            $aceType,
        [AceFlags]           $aceFlags,
        [ushort]             $aceSize,
        [EndianBinaryReader] $binaryReader
    ) {
        $this.AceType = $aceType
        $this.AceFlags = $aceFlags
        $this.aceSize = $aceSize
        $this.AccessMask = $binaryReader.ReadUInt32()

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
