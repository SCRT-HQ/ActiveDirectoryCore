class ADGroup : ADObject {
    hidden static [string[]] $DefaultProperties = [ADObject]::DefaultProperties + @(
        'SamAccountName'
        'GroupType'
    )

    [GroupCategory] $GroupCategory
    [GroupScope]    $GroupScope
    [GroupType]     $GroupType

    ADGroup([object] $entry, [string[]] $Properties) : base($entry, $Properties) { }
}
