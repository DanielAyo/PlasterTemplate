$script:ModuleName = '<%= $PLASTER_PARAM_ModuleName %>'

$base = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\examples subdirectory
if ((Split-Path $base -Leaf) -eq 'examples')
{
    $base = Split-Path $base -Parent
    $moduleBase = "$base\$ModuleName"
}
# Removes the module and then imports it again
Import-Module $moduleBase\$ModuleName.psd1 -PassThru -Force -Verbose -ErrorAction Stop

#Run a public function from module
