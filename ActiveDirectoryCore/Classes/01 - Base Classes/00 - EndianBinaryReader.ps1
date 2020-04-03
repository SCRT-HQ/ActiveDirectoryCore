class EndianBinaryReader : System.IO.BinaryReader {
    EndianBinaryReader([System.IO.Stream]$BaseStream) : base($BaseStream) { }

    [ushort] ReadUInt16([bool] $isBigEndian) {
        if ($isBigEndian) {
            return [ushort](([ushort]$this.ReadByte() -shl 8) -bor $this.ReadByte())
        } else {
            return $this.ReadUInt16()
        }
    }

    [uint] ReadUInt32([bool] $isBigEndian) {
        if ($isBigEndian) {
            return [UInt32](
                ([UInt32]$this.ReadByte() -shl 24) -bor
                ([UInt32]$this.ReadByte() -shl 16) -bor
                ([UInt32]$this.ReadByte() -shl 8) -bor
                $this.ReadByte())
        } else {
            return $this.ReadUInt32()
        }
    }

    [Byte] PeekByte() {
        $value = $this.ReadByte()
        $this.BaseStream.Seek(-1, 'Current')
        return $value
    }
}
