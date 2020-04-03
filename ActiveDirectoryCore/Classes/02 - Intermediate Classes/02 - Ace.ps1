class Ace {
    [AceType]     $Type
    [AceFlags]    $Flags
    [AccessRight] $AccessRights
    [Sid[]]       $IdentityReference

    hidden [ushort] $Size

    Ace() { }

    Ace([System.IO.BinaryReader] $binaryReader) {
        $this.Type = $binaryReader.ReadByte()
        $this.Flags = $binaryReader.ReadByte()
        $this.Size = $binaryReader.ReadUInt16()
        $this.AccessRights = $binaryReader.ReadUInt32()

        $bytesRemaining = $this.Size
        $this.IdentityReference = while ($bytesRemaining -gt $this.Size) {
            $sid = [Sid]::new($binaryReader)
            $bytesRemaining -= $sid.BinaryLength
            $sid
        }
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
