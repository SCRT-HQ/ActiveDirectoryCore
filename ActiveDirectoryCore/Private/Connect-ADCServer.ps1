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

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Port = $script:ActiveDirectoryCore.Port
    )

    try {
        $ldap = [LdapConnection]::new()
        $ldap.Connect($Server, $Port)
        $ldap.Bind(
            $Credential.UserName,
            $Credential.GetNetworkCredential().Password
        )

        $script:ActiveDirectoryCore.Connection = $ldap
        $ldap
    }
    catch {
        if ($ldap -and $ldap.Connected) {
            $ldap.Disconnect()
        }
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
