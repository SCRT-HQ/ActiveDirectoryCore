function Import-ADCoreConfig {
    <#
    .SYNOPSIS
    Allows you to import an unecrypted ADCore config from a portable JSON string format, typically created with Export-ADCoreConfig. Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

    .DESCRIPTION
    Allows you to import an unecrypted ADCore config from a portable JSON string format, typically created with Export-ADCoreConfig. Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

    .PARAMETER Json
    The Json string to import.

    .PARAMETER Path
    The path of the Json file you would like import.

    .PARAMETER Temporary
    If $true, the imported config is not stored in the config file and the imported config persists only for the current session.

    .PARAMETER PassThru
    If $true, outputs the resulting config object to the pipeline.

    .EXAMPLE
    Import-Module ActiveDirectoryCore -MinimumVersion 2.22.0
    Import-ADCoreConfig -Json '$(ADCoreConfigJson)' -Temporary

    Azure Pipelines inline script task that uses a Secure Variable named 'ADCoreConfigJson' with the Config JSON string stored in it, removing the need to include credential or key files anywhere.
    #>
    [CmdletBinding(DefaultParameterSetName = "Json")]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ParameterSetName = "Json")]
        [Alias('J')]
        [String]
        $Json,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Path")]
        [Alias('P')]
        [String]
        $Path,
        [parameter(Mandatory = $false)]
        [Alias('Temp','T')]
        [Switch]
        $Temporary,
        [parameter(Mandatory = $false)]
        [Switch]
        $PassThru
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Path {
                    Write-Verbose "Importing config from path: $Path"
                    $Script:ActiveDirectoryCore = (ConvertFrom-Json (Get-Content $Path -Raw))
                }
                Json {
                    Write-Verbose "Importing config from Json string"
                    $Script:ActiveDirectoryCore = (ConvertFrom-Json $Json)
                }
            }
            if (-not $Temporary) {
                Write-Verbose "Saving imported config"
                $Script:ActiveDirectoryCore | Set-ADCoreConfig
            }
            if ($PassThru) {
                return $Script:ActiveDirectoryCore
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
