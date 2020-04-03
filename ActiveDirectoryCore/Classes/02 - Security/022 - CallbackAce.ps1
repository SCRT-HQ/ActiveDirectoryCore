class CallbackAce : Ace {
    [byte[]] $ApplicationData

    hidden CallbackAce(
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
        $this.IdentityReference = [Sid]::new($binaryReader)
        $applicationDataSize = $this.AceSize - 8 - $this.IdentityReference.BinaryLength
        if ($applicationDataSize -gt 0) {
            $this.ApplicationData = $binaryReader.ReadBytes($applicationDataSize)
        }
    }
}
