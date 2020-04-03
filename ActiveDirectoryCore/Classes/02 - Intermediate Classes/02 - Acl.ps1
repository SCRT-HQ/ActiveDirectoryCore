class AclEnumerator : System.Collections.IEnumerator {
    hidden [int]    $position = -1
    hidden [object] $Current
    hidden [object] ${IEnumerator.Current}
    hidden [Ace[]]  $_ace

    AclEnumerator([Ace[]] $ace) {
        $this._ace = $ace
    }

    [bool] MoveNext() {
        $this.position++
        $this.Current = $this.'IEnumerator.Current' = $this._ace[$this.position]
        return $this.position -lt $this._ace.Length
    }

    [void] Reset() {
        $this.Current = $this.{IEnumerator.Current} = $null
        $this.Position = -1
    }
}

class Acl : System.Collections.IEnumerable {
    hidden [byte]   $revision
    hidden [byte]   $sbz1
    hidden [ushort] $aclSize
    hidden [ushort] $aceCount
    hidden [ushort] $sbz2
    hidden [Ace[]]  $_ace

    Acl([System.IO.BinaryReader] $binaryReader) {
        $this.revision = $binaryReader.ReadByte()
        $this.sbz1 = $binaryReader.ReadByte()
        $this.aclSize = $binaryReader.ReadUInt16()
        $this.aceCount = $binaryReader.ReadUInt16()
        $this.sbz2 = $binaryReader.ReadUInt16()

        $this._ace = for ($i = 0; $i -lt $this.aceCount; $i++) {
            [Ace]::new($binaryReader)
        }
    }

    [System.Collections.IEnumerator] GetEnumerator() {
        return [AclEnumerator]::new($this._ace)
    }

    [Byte[]] GetBytes([Ace[]] $ace) {
        $bytes = [System.Collections.Generic.List[byte]]::new()
        $bytes.Add($this.revision)
        $bytes.Add($this.sbz1)
        $bytes.AddRange([BitConverter]::GetBytes($this.aclSize))
        $bytes.AddRange([BitConverter]::GetBytes($this.aceCount))
        $bytes.AddRange([BitConverter]::GetBytes($this.sbz2))

        foreach ($ace in $this._ace) {
            $bytes.AddRange($ace.GetBytes())
        }

        return $bytes.ToArray()
    }
}
