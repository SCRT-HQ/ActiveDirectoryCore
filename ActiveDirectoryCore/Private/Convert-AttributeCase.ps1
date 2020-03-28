function Convert-AttributeCase {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name
    )
    Begin {
        $hash = @{
            AccountExpirationDate                = 'AccountExpirationDate'
            AccountLockoutTime                   = 'AccountLockoutTime'
            AccountNotDelegated                  = 'AccountNotDelegated'
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
            KerberosEncryptionType               = 'KerberosEncryptionType'
            LastBadPasswordAttempt               = 'LastBadPasswordAttempt'
            LastKnownParent                      = 'LastKnownParent'
            LastLogonDate                        = 'LastLogonDate'
            LockedOut                            = 'LockedOut'
            LogonWorkstations                    = 'LogonWorkstations'
            Manager                              = 'Manager'
            MemberOf                             = 'MemberOf'
            MNSLogonAccount                      = 'MNSLogonAccount'
            MobilePhone                          = 'MobilePhone'
            Modified                             = 'Modified'
            Name                                 = 'Name'
            ObjectCategory                       = 'ObjectCategory'
            ObjectClass                          = 'ObjectClass'
            ObjectGUID                           = 'ObjectGUID'
            Office                               = 'Office'
            OfficePhone                          = 'OfficePhone'
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
            ProtectedFromAccidentalDeletion      = 'ProtectedFromAccidentalDeletion'
            SamAccountName                       = 'SamAccountName'
            ScriptPath                           = 'ScriptPath'
            ServicePrincipalNames                = 'ServicePrincipalNames'
            SID                                  = 'SID'
            SIDHistory                           = 'SIDHistory'
            SmartcardLogonRequired               = 'SmartcardLogonRequired'
            State                                = 'State'
            StreetAddress                        = 'StreetAddress'
            Surname                              = 'Surname'
            Title                                = 'Title'
            TrustedForDelegation                 = 'TrustedForDelegation'
            TrustedToAuthForDelegation           = 'TrustedToAuthForDelegation'
            UseDESKeyOnly                        = 'UseDESKeyOnly'
            UserPrincipalName                    = 'UserPrincipalName'
            PropertyNames                        = 'PropertyNames'
            AddedProperties                      = 'AddedProperties'
            RemovedProperties                    = 'RemovedProperties'
            ModifiedProperties                   = 'ModifiedProperties'
            PropertyCount                        = 'PropertyCount'
        }
    }
    Process {
        if ($hash.ContainsKey($Name)) {
            $hash[$Name]
        }
        else {
            $Name
        }
    }
}
