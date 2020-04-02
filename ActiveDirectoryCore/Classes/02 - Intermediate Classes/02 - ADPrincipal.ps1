class ADPrincipal : ADObject {
    hidden static [string[]] $DefaultProperties = [ADObject]::DefaultProperties + @(
        'SamAccountName'
        'objectSID'
        'userAccountControl'
    )

    [string]             $SamAccountName
    [SID]                $objectSID
    [bool]               $Enabled
    [UserAccountControl] $UserAccountControl

    ADPrincipal([object] $entry, [string[]] $Properties) : base($entry, $Properties) {
        if ($this.UserAccountControl.HasFlag([UserAccountControl]::AccountDisable)) {
            $this.Enabled = $false
        }
        else {
            $this.Enabled = $true
        }
    }
}
