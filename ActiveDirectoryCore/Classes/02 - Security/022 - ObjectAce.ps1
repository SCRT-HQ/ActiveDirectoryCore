class ObjectAce : Ace {
    [ObjectAceFlags] $Flags
    [Guid]           $ObjectType
    [Guid]           $InheritedObjectType

    hidden ObjectAce(
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
    }
}
