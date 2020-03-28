$ModuleName = 'ActiveDirectoryCore'
$ProjectRoot = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
$SourceModulePath = Resolve-Path "$ProjectRoot\$ModuleName" | Select-Object -ExpandProperty Path
$TargetModulePath = Get-ChildItem "$ProjectRoot\BuildOutput\$($ModuleName)" | Sort-Object { [Version]$_.Name } | Select-Object -Last 1 -ExpandProperty FullName

Describe "Function contents" -Tag 'Module' {
    $scripts = Get-ChildItem "$SourceModulePath\Public" -Include *.ps1 -Recurse | Where-Object {$_.FullName -notlike "*Helpers*"}
    $getFunctions = $scripts | Where-Object {$_.BaseName -match '^Get'}
    $addFunctions = $scripts | Where-Object {$_.BaseName -match '^Add'}
    $newFunctions = $scripts | Where-Object {$_.BaseName -match '^New'}
    $updateFunctions = $scripts | Where-Object {$_.BaseName -match '^Update'}
    $removeFunctions = $scripts | Where-Object {$_.BaseName -match '^Remove'}
    Context "All non-helper public functions should use Write-Verbose" {
        $testCase = $scripts | Foreach-Object {@{file = $_;Name = $_.BaseName}}
        It "Function <Name> should contain verbose output" -TestCases $testCase {
            param($file,$Name)
            $file.fullname | Should -FileContentMatch 'Write-Verbose'
        }
    }
    foreach ($verb in @('New','Update','Remove')) {
        $functionsToTest = switch ($verb) {
            New {$newFunctions}
            Update {$updateFunctions}
            Remove {$removeFunctions}
        }
        if ($null -ne $functionsToTest) {
            Context "All '$verb' functions should SupportsShouldProcess" {
                $testCase = $functionsToTest | Foreach-Object {@{file = $_;Name = $_.BaseName}}
                It "Function <Name> should contain SupportsShouldProcess" -TestCases $testCase {
                    param($file,$Name)
                    $file.fullname | Should -FileContentMatch 'SupportsShouldProcess'
                }
            }
            Context "All '$verb' functions should contain 'PSCmdlet.ShouldProcess'" {
                $testCase = $functionsToTest | Foreach-Object {@{file = $_;Name = $_.BaseName}}
                It "Function <Name> should contain PSCmdlet.ShouldProcess" -TestCases $testCase {
                    param($file,$Name)
                    $file.fullname | Should -FileContentMatch '\$PSCmdlet.ShouldProcess'
                }
            }
        }
    }
}
