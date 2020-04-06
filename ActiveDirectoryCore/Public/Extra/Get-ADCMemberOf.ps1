function Get-ADMemberOf {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ADUser]
        [Alias('sAMAccountName')]
        $Identity = $(switch($true){{$env:UserName}{$env:UserName;break};{$env:USER}{$env:USER;break}}),
        [Parameter(Position = 1, ValueFromRemainingArguments)]
        [String]
        $Pattern,
        [Parameter()]
        [Switch]
        $IncludeFullDN,
        [Parameter()]
        [Switch]
        $NoSort
    )
    Process {
        $list = (Get-ADCUser -Identity $Identity -Property MemberOf).MemberOf
        if (-not $IncludeFullDN) {
            $list = $list | ForEach-Object {
                $_.Split(',')[0].Split('=')[1]
            }
        }
        if ($PSBoundParameters.ContainsKey('Pattern')) {
            $list = $list | Where-Object { $_ -match $Pattern }
        }
        if (-not $NoSort) {
            $list = $list | Sort-Object
        }
        $list
    }
}
