#region:TestFileHeader
$projectRoot = $PSScriptRoot.Substring(0, $PSScriptRoot.IndexOf(([IO.Path]::DirectorySeparatorChar + "Tests")))
$moduleName = Split-Path $projectRoot -Leaf
$module = Join-Path -Path $projectRoot -ChildPath "BuildOutput\$moduleName\*\$moduleName.psd1" | Resolve-Path

Import-Module $module -Force
#endregion

InModuleScope ActiveDirectoryCore {
    Describe SID {
        BeforeAll {
            $testCases = @(
                @{ SID = 'S-1-1-0';                                       SIDBytes = 'AQEAAAAAAAEAAAAA' }
                @{ SID = 'S-1-5-32-544';                                  SIDBytes = 'AQIAAAAAAAUgAAAAIAIAAA==' }
                @{ SID = 'S-1-5-21-2114566378-1333126016-908539190-1001'; SIDBytes = 'AQUAAAAAAAUVAAAA6rgJfoDjdU82NSc26QMAAA==' }
            )
        }

        It 'can parse the SID string <SID> without error' -TestCases $testCases {
            param ( [string]$SID )

            { [SID]::new($SID) } | Should -Not -Throw
        }

        It 'can convert the SID string <SID> to binary' -TestCases $testCases {
            param ( [string]$SID, [string]$SIDBytes )

            [SID]::new($SID).GetBytes() | Should -Be ([Convert]::FromBase64String($SIDBytes))
        }

        It 'can convert the SID bytes to the SID string <SID>' -TestCase $testCases {
            param ( [string]$SID, [string]$SIDBytes )

            [SID]::new([Convert]::FromBase64String($SIDBytes)).ToString() | Should -Be $SID
        }

        It 'can cast <SID> to SecurityIdentifier on the Windows platform' -TestCases $testCases  {
            param ( [string]$SID )

            if ($PSVersionTable.Platform -ne 'Win32NT') {
                Set-ItResult -Inconclusive -Because 'This test is only supported on the Windows platform'
            }
            else {
                { [System.Security.Principal.SecurityIdentifier][Sid]::new($SID) } | Should -Not -Throw
            }
        }

        It 'can cast a SecurityIdentifier <SID> to SID on the Windows platform' -TestCases $testCases  {
            param ( [string]$SID )

            if ($PSVersionTable.Platform -ne 'Win32NT') {
                Set-ItResult -Inconclusive -Because 'This test is only supported on the Windows platform'
            }
            else {
                { [SID][System.Security.Principal.SecurityIdentifier]$SID } | Should -Not -Throw
            }
        }

        It 'can compare <SID> to an instance of SecurityIdentifier on the Windows platform' -TestCases $testCases {
            param ( [string]$SID )

            if ($PSVersionTable.Platform -ne 'Win32NT') {
                Set-ItResult -Inconclusive -Because 'This test is only supported on the Windows platform'
            }
            else {
                [SID]$SID -eq [System.Security.Principal.SecurityIdentifier]$SID | Should -BeTrue
            }
        }

        It 'can compare <SID> to a byte array' -TestCases $testCases {
            param ( [string]$SID, [string]$SIDBytes )

            if ($PSVersionTable.Platform -ne 'Win32NT') {
                Set-ItResult -Inconclusive -Because 'This test is only supported on the Windows platform'
            }
            else {
                [SID]$SID -eq ([Convert]::FromBase64String($SIDBytes)) | Should -BeTrue
            }
        }
    }
}
