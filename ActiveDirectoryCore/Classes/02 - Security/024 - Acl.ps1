class Acl {
    [byte]   $revision
    [byte]   $sbz1
    [ushort] $aclSize
    [ushort] $aceCount
    [ushort] $sbz2
    [Ace[]]  $ace

    Acl([EndianBinaryReader] $binaryReader) {
        $this.revision = $binaryReader.ReadByte()
        $this.sbz1 = $binaryReader.ReadByte()
        $this.aclSize = $binaryReader.ReadUInt16()
        $this.aceCount = $binaryReader.ReadUInt16()
        $this.sbz2 = $binaryReader.ReadUInt16()

        $this.ace = for ($i = 0; $i -lt $this.aceCount; $i++) {
            [Ace]::Parse($binaryReader)
        }
    }
}
