function Disconnect-ADCServer {
    <#
    .SYNOPSIS
    Disconnects from an Active Directory server.

    .DESCRIPTION
    Disconnects from an Active Directory server.
    #>

    [CmdletBinding()]
    param ( )

    $ldap = $script:ActiveDirectoryCore.Connection

    if ($ldap -and $ldap.Connected) {
        $ldap.Disconnect()
    }
}
