if (-not(Get-Module -ListAvailable -Name "PSScriptAnalyzer"))
{
    Write-Warning "Installing latest version of PSScriptAnalyzer"
    # Install PSScriptAnalyzer
    Install-Module PSScriptAnalyzer -Force -Scope CurrentUser
}

$script:ModuleName = '<%= $PLASTER_PARAM_ModuleName %>'

$base = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get the list of Pester Tests we are going to skip
$PesterTestExceptions = Get-Content -Path "$base\Integration.Exceptions.txt"

# For tests in .\Tests subdirectory
if ((Split-Path $base -Leaf) -eq 'Tests')
{
    $base = Split-Path $base -Parent
    $moduleBase = "$base\$ModuleName"
}

Describe "PSScriptAnalyzer rule-sets" -Tag Build , ScriptAnalyzer {

    $Rules = Get-ScriptAnalyzerRule
    $scripts = Get-ChildItem $moduleBase -Include *.ps1, *.psm1, *.psd1 -Recurse | Where-Object fullname -notmatch 'classes'

    foreach ( $Script in $scripts )
    {
        Context "Script '$($script.FullName)'" {

            foreach ( $rule in $rules )
            {
                # Skip all rules that are on the exclusions list
                if ($PesterTestExceptions -contains $rule.RuleName) { continue }
                It "Rule [$rule]" {
                    (Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }
        }
    }
}


Describe "General project validation: $moduleName" -Tags Build {
    BeforeAll {
        # - Arrange
        Get-Module -ListAvailable $moduleBase\$ModuleName.psm1 | Remove-Module
    }

    $scripts = Get-ChildItem $moduleBase -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | ForEach-Object { @{file = $_ } }
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }
    It "Module '$ModuleName' can import cleanly" {
        # - Act
        $module = Import-Module $moduleBase\$ModuleName.psd1 -PassThru -Force -ErrorAction SilentlyContinue
        # - Assert
        $module | Should -Not -BeNullOrEmpty -Because 'the module should have returned a PSModuleInfo object type'
    }
}
