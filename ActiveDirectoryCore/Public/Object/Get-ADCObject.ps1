function Get-ADCObject {
    <#
    .SYNOPSIS
    Gets a directory object

    .DESCRIPTION
    Gets a directory object

    .PARAMETER Identity
    Specifies an Active Directory object by providing one of the following property values. The identifier in parentheses is the LDAP display name for the attribute. The acceptable values for this parameter are:
    * A distinguished name
    * A GUID (objectGUID)

    The cmdlet searches the default naming context or partition to find the object. If two or more objects are found, the cmdlet returns a non-terminating error.

    This parameter can also get this object through the pipeline or you can set this parameter to an object instance.

    .PARAMETER LdapFilter
    Specifies an LDAP query string that is used to filter Active Directory objects. You can use this parameter to run your existing LDAP queries. The Filter parameter syntax supports the same functionality as the LDAP syntax.

    .PARAMETER Properties
    Specifies the properties of the output object to retrieve from the server. Use this parameter to retrieve properties that are not included in the default set.

    Specify properties for this parameter as a comma-separated list of names. To display all of the attributes that are set on the object, specify * (asterisk).

    To specify an individual extended property, use the name of the property. For properties that are not default or extended properties, you must specify the LDAP display name of the attribute.

    To retrieve properties and display them for an object, you can use the Get-* cmdlet associated with the object and pass the output to the Get-Member cmdlet.

    .PARAMETER SearchBase
    Specifies an Active Directory path to search.

    When you run a cmdlet outside of an Active Directory provider drive against an AD DS target, the default value of this parameter is the default naming context of the target domain.

    When you run a cmdlet outside of an Active Directory provider drive against an AD LDS target, the default value is the default naming context of the target AD LDS instance if one has been specified by setting the msDS-defaultNamingContext property of the Active Directory directory service agent object (nTDSDSA) for the AD LDS instance. If no default naming context has been specified for the target AD LDS instance, then this parameter has no default value.

    When the value of the SearchBase parameter is set to an empty string and you are connected to a global catalog (GC) port, all partitions are searched. If the value of the SearchBase parameter is set to an empty string and you are not connected to a GC port, an error is thrown.

    .PARAMETER SearchScope
    Specifies the scope of an Active Directory search. The acceptable values for this parameter are:
    * Base or 0
    * OneLevel or 1
    * Subtree or 2

    A Base query searches only the current path or object. A OneLevel query searches the immediate children of that path or object. A Subtree query searches the current path or object and all children of that path or object.

    .PARAMETER Credential
    Specifies the user account credentials to use to perform this task.

    To specify this parameter, you can type a user name, such as User1@Domain01.com or Domain01\User01 or you can specify a PSCredential object. If you specify a user name for this parameter, the cmdlet prompts for a password.

    You can also create a PSCredential object by using a script or by using the Get-Credential cmdlet. You can then set the Credential parameter to the PSCredential object.

    If the acting credentials do not have directory-level permission to perform the task, the ActiveDirectoryCore module returns a terminating error.

    .PARAMETER Server
    Specifies the AD DS instance to connect to, by providing one of the following values for a corresponding domain name or directory server. The service may be any of the following: AD LDS, AD DS, or Active Directory snapshot instance.

    Specify the AD DS instance in one of the following ways:

    Domain name values:
    * Fully qualified domain name
    * NetBIOS name

    Directory server values:
    * Fully qualified directory server name
    * NetBIOS name
    * Fully qualified directory server name and port

    The default value for this parameter is determined by one of the following methods in the order that they are listed:
    * By using the Server value from objects passed through the pipeline
    * By using the server information associated with the AD DS Windows PowerShell provider drive, when the cmdlet runs in that drive
    * By using the domain of the computer running Windows PowerShell

    .PARAMETER Port
    The port of the target directory server to connect to.

    Defaults to 389

    .EXAMPLE
    Get-ADCObject -Credential (Get-Credential domain\admin) -LdapFilter "(&(sAMAccountName=jshmoe)(objectClass=user))" -Server 'dom-dc-1' -SearchBase "DC=domain,DC=com"

    # This will connect to the domain controller 'dom-dc-1' using credentials for user admin@domain.com and search for a user with a sAMAccountName of 'jshmoe' from the root of the domain.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Identity')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'Identity')]
        [Alias('sAMAccountName','DistinguishedName','SID')]
        [object]
        $Identity,
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'LdapFilter')]
        [string]
        $LdapFilter,
        [Parameter()]
        [Alias('Property')]
        [string[]]
        $Properties,
        [Parameter()]
        [string]
        $SearchBase,
        [Parameter()]
        [ValidateSet('Base', 'OneLevel', 'SubTree')]
        [string]
        $SearchScope = 'SubTree',
        [Parameter(Position = 1)]
        [pscredential]
        $Credential = $script:ActiveDirectoryCore.Credential,
        [Parameter(Position = 2)]
        [string]
        $Server = $script:ActiveDirectoryCore.Server,
        [Parameter(Position = 2)]
        [int]
        $Port = $script:ActiveDirectoryCore.Port
    )
    Begin {
        $props = @(
            'DistinguishedName'
            'Enabled'
            'GivenName'
            'Name'
            'ObjectClass'
            'ObjectGUID'
            'ObjectSID'
            'SamAccountName'
            'Surname'
            'UserPrincipalName'
        )
        if ($PSBoundParameters.ContainsKey('Properties')) {
            $props += $Properties
        }
        try {
            if ($null -eq $script:ActiveDirectoryCore.Connection) {
                $ldap = [LdapConnection]::new()
                $ldap.Connect($Server, $Port)
                $ldap.Bind($Credential.UserName, $Credential.GetNetworkCredential().Password)
                $script:ActiveDirectoryCore.Connection = $ldap.Clone()
                $script:ActiveDirectoryCore.Credential = $Credential
                $script:ActiveDirectoryCore.Server = $Server
                $script:ActiveDirectoryCore.Port = $Port
            }
            else {
                $ldap = $script:ActiveDirectoryCore.Connection.Clone()
            }
        }
        catch {
            if ($ldap -and $ldap.Connected) {
                $ldap.Disconnect()
            }
            $PSCmdlet.ThrowTerminatingError($_)
        }
        $scope = switch ($SearchScope) {
            Base {
                [LdapConnection]::ScopeBase
            }
            OneLevel {
                [LdapConnection]::ScopeOne
            }
            SubTree {
                [LdapConnection]::ScopeSub
            }
        }
    }
    Process {
        $ldapFil = switch ($PSCmdlet.ParameterSetName) {
            Identity {
                "(sAMAccountName=$Identity)"
            }
            LdapFilter {
                $LdapFilter
            }
        }
        Write-Verbose "Searching with LDAP filter: $ldapFil"
        [LdapSearchQueue]$queue = $ldap.Search($SearchBase, $scope, $ldapFil, $props, $false, $null, $null)
        while ([LdapMessage]$message = $queue.GetResponse()) {
            if ($message -is [LdapSearchResult]) {
                [LdapEntry]$entry = $message.Entry
                $user = @{distinguishedName = $entry.DN }
                [LdapAttributeSet]$atts = $entry.GetAttributeSet()
                $atts.GetEnumerator() | ForEach-Object {
                    [LdapAttribute]$att = $_
                    $attVal = if ($att.Name -match '(certificate|objectSid|objectGUID|mSMQDigests)') {
                        $att.ByteValue
                    }
                    elseif ($att.Name -match '(memberOf|directReports|msDS-AuthenticatedAtDC|dSCorePropagationData|otherIpPhone|otherTelephone)') {
                        $att.StringValues
                    }
                    else {
                        $att.StringValue
                    }
                    $user[$(Convert-AttributeCase -Name $att.Name)] = $attVal
                }
                $final = [Ordered]@{ }
                $user.GetEnumerator() | Sort-Object Key | ForEach-Object {
                    $final[$_.Key] = $_.Value
                }
                [PSCustomObject]$final
            }
        }
    }
    End {
        if ($ldap -and $ldap.Connected) {
            $ldap.Disconnect()
        }
    }
}
