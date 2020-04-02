function Show-ADCoreConfig {
    <#
    .SYNOPSIS
    Returns the current session configuration for the module.

    .DESCRIPTION
    Returns the current session configuration for the module.

    .EXAMPLE
    Show-ADCoreConfig
    #>
    [CmdletBinding()]
    Param( )
    Process {
        $Script:ActiveDirectoryCore
    }
}
