$script:ModuleName = '<%= $PLASTER_PARAM_ModuleName %>'

# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module

$base = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Tests subdirectory
if ((Split-Path $base -Leaf) -eq 'Tests') {
    $base = Split-Path $base -Parent
    $moduleBase = "$base\$ModuleName"
}

## This variable is for the VSTS tasks and is to be used for referencing any mock artifacts
# $Env:ModuleBase = $ModuleBase

Import-Module $moduleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop | Out-Null

# InModuleScope runs the test in module scope.
# It creates all variables and functions in module scope.
# As a result, test has access to all functions, variables and aliases
# in the module even if they're not exported.
InModuleScope $script:ModuleName {
    Describe "Basic function unit tests" -Tags Build , Unit {

    }

}
