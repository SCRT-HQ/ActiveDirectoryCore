class ADObject {
    # Novell will just ignore any extra properties,
    # so this will cover most/all default properties as the root.
    hidden static [string[]] $DefaultProperties = @(
        'DistinguishedName'
        'Name'
        'ObjectClass'
        'ObjectGUID'
        'ObjectSID'
        'UserPrincipalName'
    )

    hidden static [hashtable] $AttributeSyntax
    hidden static [System.Globalization.CultureInfo] $Culture = (Get-Culture)

    [string]   $Name
    [string]   $DistinguishedName
    [string[]] $ObjectClass
    [GUID]     $objectGUID

    hidden ADObject() { }

    ADObject([object] $entry, [string[]] $Properties) {
        $this.DistinguishedName = $entry.DN
        $domainDN = 'DC' + $entry.DN.Split('DC', 2)[1]
        if ($script:ActiveDirectoryCore.DomainDN -ne $domainDN) {
            $script:ActiveDirectoryCore.DomainDN = $domainDN
        }
        if ($Properties -ne '*') {
            foreach ($property in ($Properties | Sort-Object)) {
                try {
                    $attribute = $entry.GetAttribute($property)

                    $value = 0
                    if (-not $this.TryConvertValue($property, $attribute, [ref] $value)) {
                        $value = $attribute.ByteValue
                    }
                }
                catch [System.Collections.Generic.KeyNotFoundException] {
                    $value = $null
                }
                catch {
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
        else {
            foreach ($attribute in ($entry.GetAttributeSet().GetEnumerator() | Sort-Object { $_.Name })) {
                <#
                $this.AddNoteProperty(
                    [ADCoreUtility]::ConvertAttributeName($attribute.Name),
                    [ADCoreUtility]::ConvertAttributeValue($attribute)
                )
                #>
                try {
                    $value = 0
                    if (-not $this.TryConvertValue($attribute.Name, $attribute, [ref] $value)) {
                        $value = $attribute.ByteValue
                    }
                }
                catch [System.Collections.Generic.KeyNotFoundException] {
                    $value = $null
                }
                catch {
                    throw
                }
                $newProperty = [ADCoreUtility]::ConvertAttributeName($attribute.Name)
                if ($this.PSObject.Properties.Item($newProperty)) {
                    $this.$newProperty = $value
                }
                else {
                    $this.AddNoteProperty($newProperty, $value)
                    if ($this.PSObject.Properties.Item($attribute.Name)) {
                        $this.AddNoteProperty($attribute.Name, $value)
                    }
                }
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
                'GeneralizedTime' {
                    $date = [DateTime]::UtcNow
                    $parseResult = [DateTime]::TryParseExact(
                        $attribute.StringValue,
                        'yyyyMMddHHmmss.f"Z"',
                        [ADObject]::Culture,
                        [System.Globalization.DateTimeStyles]::AssumeUniversal,
                        [ref]$date
                    )
                    if ($parseResult) {
                        $converted.Value = $date
                        return $true
                    }
                }
                'LargeInteger' {
                    $converted.Value = $attribute.StringValue -as [UInt64]
                    return $true
                }
                'Object' {
                    switch ($syntax.attributeSyntax) {
                        '2.5.5.1' {
                            $converted.Value = $attribute.StringValueArray
                            return $true
                        }
                    }
                }
                'NTSecDesc' {
                    $converted.Value = [SecurityDescriptor]::new($attribute.ByteValue)
                    return $true
                }
                { $_ -in 'Unicode', 'OID' } {
                    $converted.Value = foreach ($string in $attribute.StringValueArray) {
                        $string
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
