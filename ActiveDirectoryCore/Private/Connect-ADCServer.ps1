function Connect-ADCServer {
    <#
    .SYNOPSIS
    Connects to an Active Directory server.

    .DESCRIPTION
    Creates a connection to Active Directory Services.

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
    #>

    [CmdletBinding()]
    [OutputType([Novell.Directory.Ldap.LdapConnection])]
    param (
        [Parameter()]
        [pscredential]
        $Credential = $script:ActiveDirectoryCore.Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Server = $script:ActiveDirectoryCore.Server,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]
        $Port = $script:ActiveDirectoryCore.Port,

        [Parameter(ValueFromRemainingArguments,Position = 0)]
        [object]
        $Remaining
    )

    try {
        if (
            $null -eq $script:ActiveDirectoryCore.Connection -or
            -not $script:ActiveDirectoryCore.Connection.Connected -or
            $PSBoundParameters.ContainsKey('Credential') -or
            $PSBoundParameters.ContainsKey('Server') -or
            $PSBoundParameters.ContainsKey('Port')
        ) {
            $script:ActiveDirectoryCore.Connection = [LdapConnection]::new()
            $script:ActiveDirectoryCore.Connection.Connect($Server, $Port)
            if ($null -eq $Credential) {
                $script:ActiveDirectoryCore.Connection.Bind()
            }
            else {
                $script:ActiveDirectoryCore.Connection.Bind($Credential.UserName, $Credential.GetNetworkCredential().Password)
                $script:ActiveDirectoryCore.Credential = $Credential
            }
            $script:ActiveDirectoryCore.Server = $Server
            $script:ActiveDirectoryCore.Port = $Port
        }
        $script:ActiveDirectoryCore.Connection.Clone()
    }
    catch {
        if ($script:ActiveDirectoryCore.Connection -and $script:ActiveDirectoryCore.Connection.Connected) {
            $script:ActiveDirectoryCore.Connection.Disconnect()
        }
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
