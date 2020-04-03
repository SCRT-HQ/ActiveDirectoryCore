class AuditObjectAce : ObjectAce {
    [byte[]] $ApplicationData

    hidden AuditObjectAce(
        [AceType]            $aceType,
        [AceFlags]           $aceFlags,
        [ushort]             $aceSize,
        [EndianBinaryReader] $binaryReader
    ) : base(
        $aceType,
        $aceFlags,
        $aceSize,
        $binaryReader
    ) { }

    hidden [void] ReadAce([EndianBinaryReader] $binaryReader) {
        $this.Flags = $binaryReader.ReadUInt32()

        if ($this.Flags.HasFlag([ObjectAceFlags]::ObjectTypePresent)) {
            $this.ObjectType = $binaryReader.ReadBytes(16)
        }
        if ($this.Flags.HasFlag([ObjectAceFlags]::InheritedObjectTypePresent)) {
            $this.InheritedObjectType = $binaryReader.ReadBytes(16)
        }
        $this.IdentityReference = [Sid]::new($binaryReader)

        $applicationDataSize = $this.AceSize - 12 - $this.IdentityReference.BinaryLength
        if ($this.ObjectType) {
            $applicationDataSize -= 16
        }
        if ($this.InheritedObjectType) {
            $applicationDataSize -= 16
        }
        if ($applicationDataSize -gt 0) {
            $this.ApplicationData = $binaryReader.ReadBytes($applicationDataSize)
        }
    }
}
