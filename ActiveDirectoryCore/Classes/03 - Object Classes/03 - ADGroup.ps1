class ADGroup {
    hidden static [string[]] $DefaultProperties = [ADObject]::DefaultProperties + @(
        'SamAccountName'
        'objectSID'
        'groupType'
    )

    [GroupCategory] $GroupCategory
    [GroupScope]    $GroupScope
    [GroupType]     $GroupType

    ADGroup([object] $entry, [string[]] $Properties) : base($entry, $Properties) { }
}
