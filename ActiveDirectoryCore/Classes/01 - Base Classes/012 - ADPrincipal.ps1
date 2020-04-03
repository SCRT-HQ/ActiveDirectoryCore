class ADPrincipal : ADObject {
    hidden static [string[]] $DefaultProperties = [ADObject]::DefaultProperties + @(
        'Enabled'
        'SamAccountName'
        'UserAccountControl'
    )

    [string]             $SamAccountName
    [SID]                $ObjectSID
    [bool]               $Enabled
    [UserAccountControl] $UserAccountControl

    ADPrincipal([object] $entry, [string[]] $Properties) : base($entry, $Properties) {
        $this.Enabled = (-not $this.UserAccountControl.HasFlag([UserAccountControl]::AccountDisable))
    }
}
