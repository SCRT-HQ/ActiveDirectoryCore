class ADCoreUtility {
    # Utilities / static methods / etc
    hidden ADCoreUtility() { }

    static [string] ParseFilterFromIdentity([string] $string) {
        $property = switch ($true) {
            { $string -match '^.*,DC=.*,DC=.*$' } {
                'dn'
            }
            { $string -match '^.*\@.*\..*$' } {
                'userPrincipalName'
            }
            { $string -as [Guid] } {
                'objectGUID'
            }
            { $string -as [SID] } {
                'objectSID'
            }
            default {
                $null
            }
        }
        $final = if ($null -eq $property) {
            '(|(sAMAccountName={0})(name={0}))' -f $string
        }
        else {
            "($property={0})" -f $string
        }
        return $final
    }

    static [object] ConvertAttributeValue([object] $attribute) {
        $value = switch -Regex ($attribute.Name) {
            '^objectSid$' {
                [SID]::new(([byte[]]$attribute.ByteValue))
            }
            '^objectGUID$' {
                [Guid]::new(([byte[]]$attribute.ByteValue))
            }
            '^userAccountControl$' {
                [userAccountControl]$attribute.StringValue
            }
            '^objectClass$' {
                $attribute.StringValues | Select-Object -Last 1
            }
            '(certificate|objectGUID|mSMQDigests)' {
                $attribute.ByteValue
            }
            '(^member$|objectClass|memberOf|directReports|msDS-AuthenticatedAtDC|dSCorePropagationData|otherIpPhone|otherTelephone)' {
                $attribute.StringValues
            }
            default {
                $attribute.StringValue
            }
        }
        return $value
    }

    static [string] ConvertAttributeName([string] $name) {
        $hash = @{
            AccountExpirationDate                = 'AccountExpirationDate'
            AccountLockoutTime                   = 'AccountLockoutTime'
            AccountNotDelegated                  = 'AccountNotDelegated'
            AddedProperties                      = 'AddedProperties'
            AllowReversiblePasswordEncryption    = 'AllowReversiblePasswordEncryption'
            AuthenticationPolicy                 = 'AuthenticationPolicy'
            AuthenticationPolicySilo             = 'AuthenticationPolicySilo'
            BadLogonCount                        = 'BadLogonCount'
            CannotChangePassword                 = 'CannotChangePassword'
            CanonicalName                        = 'CanonicalName'
            Certificates                         = 'Certificates'
            City                                 = 'City'
            CN                                   = 'CN'
            Company                              = 'Company'
            CompoundIdentitySupported            = 'CompoundIdentitySupported'
            Country                              = 'Country'
            Created                              = 'Created'
            Deleted                              = 'Deleted'
            Department                           = 'Department'
            Description                          = 'Description'
            DisplayName                          = 'DisplayName'
            DistinguishedName                    = 'DistinguishedName'
            Division                             = 'Division'
            DNSHostName                          = 'DNSHostName'
            DoesNotRequirePreAuth                = 'DoesNotRequirePreAuth'
            EmailAddress                         = 'EmailAddress'
            EmployeeID                           = 'EmployeeID'
            EmployeeNumber                       = 'EmployeeNumber'
            Enabled                              = 'Enabled'
            Fax                                  = 'Fax'
            GivenName                            = 'GivenName'
            HomeDirectory                        = 'HomeDirectory'
            HomedirRequired                      = 'HomedirRequired'
            HomeDrive                            = 'HomeDrive'
            HomePage                             = 'HomePage'
            HomePhone                            = 'HomePhone'
            Initials                             = 'Initials'
            IPv4Address                          = 'IPv4Address'
            IPv6Address                          = 'IPv6Address'
            KerberosEncryptionType               = 'KerberosEncryptionType'
            LastBadPasswordAttempt               = 'LastBadPasswordAttempt'
            LastKnownParent                      = 'LastKnownParent'
            LastLogonDate                        = 'LastLogonDate'
            Location                             = 'Location'
            LockedOut                            = 'LockedOut'
            LogonWorkstations                    = 'LogonWorkstations'
            ManagedBy                            = 'ManagedBy'
            Manager                              = 'Manager'
            MemberOf                             = 'MemberOf'
            MNSLogonAccount                      = 'MNSLogonAccount'
            MobilePhone                          = 'MobilePhone'
            Modified                             = 'Modified'
            ModifiedProperties                   = 'ModifiedProperties'
            Name                                 = 'Name'
            ObjectCategory                       = 'ObjectCategory'
            ObjectClass                          = 'ObjectClass'
            ObjectGUID                           = 'ObjectGUID'
            Office                               = 'Office'
            OfficePhone                          = 'OfficePhone'
            OperatingSystem                      = 'OperatingSystem'
            OperatingSystemHotfix                = 'OperatingSystemHotfix'
            OperatingSystemServicePack           = 'OperatingSystemServicePack'
            OperatingSystemVersion               = 'OperatingSystemVersion'
            Organization                         = 'Organization'
            OtherName                            = 'OtherName'
            PasswordExpired                      = 'PasswordExpired'
            PasswordLastSet                      = 'PasswordLastSet'
            PasswordNeverExpires                 = 'PasswordNeverExpires'
            PasswordNotRequired                  = 'PasswordNotRequired'
            POBox                                = 'POBox'
            PostalCode                           = 'PostalCode'
            PrimaryGroup                         = 'PrimaryGroup'
            PrincipalsAllowedToDelegateToAccount = 'PrincipalsAllowedToDelegateToAccount'
            ProfilePath                          = 'ProfilePath'
            PropertyCount                        = 'PropertyCount'
            PropertyNames                        = 'PropertyNames'
            ProtectedFromAccidentalDeletion      = 'ProtectedFromAccidentalDeletion'
            RemovedProperties                    = 'RemovedProperties'
            SamAccountName                       = 'SamAccountName'
            ScriptPath                           = 'ScriptPath'
            ServiceAccount                       = 'ServiceAccount'
            ServicePrincipalNames                = 'ServicePrincipalNames'
            SID                                  = 'SID'
            SIDHistory                           = 'SIDHistory'
            SmartcardLogonRequired               = 'SmartcardLogonRequired'
            sn                                   = 'Surname'
            State                                = 'State'
            StreetAddress                        = 'StreetAddress'
            string                               = 'Surname'
            Surname                              = 'Surname'
            Title                                = 'Title'
            TrustedForDelegation                 = 'TrustedForDelegation'
            TrustedToAuthForDelegation           = 'TrustedToAuthForDelegation'
            UseDESKeyOnly                        = 'UseDESKeyOnly'
            UserPrincipalName                    = 'UserPrincipalName'
        }
        if ($hash.ContainsKey($name)) {
            return $hash[$name]
        }
        else {
            return $name
        }
    }
}
