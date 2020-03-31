class ADObject {
    [string] $Name
    [string] $DistinguishedName
    [string] $ObjectClass

    hidden ADObject() {
        foreach ($property in $this.RequestedProperties) {
            $this
        }
    }

    ADObject([object] $PropertySet) {
        foreach ($property in $PropertySet) {
            $this.AddNoteProperty()
        }
    }

    hidden [void] AddNoteProperty([string] $name, [object] $value) {
        $this.PSObject.Properties.Add(
            [System.Management.Automation.PSNoteProperty]::new(
                $name,
                $value
            )
        )
    }
}
