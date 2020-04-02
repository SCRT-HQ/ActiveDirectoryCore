function Disconnect-ADCServer {
    <#
    .SYNOPSIS
    Disconnects from an Active Directory server.

    .DESCRIPTION
    Disconnects from an Active Directory server.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position = 0)]
        [AllowNull()]
        [Novell.Directory.Ldap.LdapConnection]
        $Connection
    )
    if ($null -ne $Connection -and $Connection.Connected) {
        $Connection.Disconnect()
    }
}
