function Convert-AttributeValue {
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [LdapAttribute[]]
        $LdapAttribute,
        [Parameter()]
        [switch]
        $Raw
    )
    Process {
        foreach ($att in $LdapAttribute) {
            if ($Raw) {
                $att
            }
            else {
                switch -Regex ($att.Name) {
                    '^objectSid$' {
                        [SID]::new(([byte[]]$att.ByteValue))
                    }
                    '^objectGUID$' {
                        [Guid]::new(([byte[]]$att.ByteValue))
                    }
                    '^userAccountControl$' {
                        [userAccountControl]$att.StringValue
                    }
                    '^objectClass$' {
                        $att.StringValues | Select-Object -Last 1
                    }
                    '(certificate|objectGUID|mSMQDigests)' {
                        $att.ByteValue
                    }
                    '(objectClass|memberOf|directReports|msDS-AuthenticatedAtDC|dSCorePropagationData|otherIpPhone|otherTelephone)' {
                        $att.StringValues
                    }
                    default {
                        $att.StringValue
                    }
                }
            }
        }
    }
}
