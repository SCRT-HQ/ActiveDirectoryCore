class ADObject {
    hidden static [string[]] $DefaultProperties = @(
        'name'
        'objectClass'
        'objectGUID'
    )

    hidden static [hashtable] $AttributeSyntax

    [string]   $Name
    [string]   $DistinguishedName
    [string[]] $ObjectClass
    [GUID]     $objectGUID

    hidden ADObject() {}

    ADObject([object] $entry, [string[]] $Properties) {
        $this.DistinguishedName = $entry.DN

        foreach ($property in $Properties) {
            try {
                $attribute = $entry.GetAttribute($property)

                $value = 0
                if (-not $this.TryConvertValue($property, $attribute, [ref] $value)) {
                    $value = $attribute.ByteValue
                }
            } catch [System.Collections.Generic.KeyNotFoundException] {
                $value = $null
            } catch {
                throw
            }

            if ($this.PSObject.Properties.Item($property)) {
                $this.$property = $value
            }
            else {
                $this.AddNoteProperty($property, $value)
            }
        }
    }

    hidden [bool] TryConvertValue([string] $name, [object] $attribute, [ref] $converted) {
        if ([ADObject]::AttributeSyntax.Contains($name.ToLower())) {
            $syntax = [ADObject]::AttributeSyntax[$name.ToLower()]

            switch ($syntax.oMSyntax -as [omSyntax] -as [string]) {
                'Boolean' {
                    $converted.Value = $attribute.ByteValue[0] -as [bool]
                    return $true
                }
                'Integer' {
                    $int = 0
                    if ([int]::TryParse($attribute.StringValue, [ref]$int)) {
                        $converted.Value = $int
                        return $true
                    }
                }
                'Enumeration' {
                    if (($enum = $name -as [Type]) -and $enum -is [Enum]) {
                        $method = 'To{0}' -f $enum.GetEnumUnderlyingType().Name
                        $converted.Value = [BitConverter]::"$method"($attribute.ByteValue, 0)
                    }
                    $converted.Value = $attribute.ByteValue
                    return $true
                }
                { $_ -in 'Unicode', 'OID' } {
                    $converted.Value = foreach ($byteArray in $attribute.ByteValueArray) {
                        [System.Text.Encoding]::UTF8.GetString($byteArray)
                    }
                    return $true
                }
            }
        }
        return $false
    }

    hidden [void] AddNoteProperty([string] $name, [object] $value) {
        $this.PSObject.Properties.Add(
            [System.Management.Automation.PSNoteProperty]::new(
                $name,
                $value
            )
        )
    }
}
