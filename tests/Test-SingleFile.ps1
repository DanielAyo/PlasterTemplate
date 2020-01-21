param(
    [Parameter(Mandatory)]
    [string]
    $FileToTest
)

$fileToTest = Resolve-Path $FileToTest
$fileName = Split-Path $fileToTest -leaf
if ($fileName -like "*.tests.ps1")
{
    $filename = $fileName -replace "tests\.ps1$", "ps1"
    $sourceDir = Join-Path $PSScriptRoot '<%= $PLASTER_PARAM_ModuleName %>'
    $functionFile = Get-ChildItem $sourceDir -Filter $fileName -Recurse | Select-Object -First 1 -ExpandProperty FullName
    $testFile = $FileToTest
}
else
{
    $fileName = $fileName -replace ".ps1$", ".tests.ps1"
    $testFile = (Join-Path $PSScriptRoot "$fileName")
    $functionFile = $FileToTest
}

Invoke-Pester -Script $testFile -CodeCoverage $functionFile -CodeCoverageOutputFile "$PSScriptRoot\cov.xml"
