# Understanding Tests

This template comes with the following files:

* **Help.Exceptions.txt** - If there are functions you wish to exclude from the Comment Based Help tests, place their names in this file.
* **Help.Tests.ps1** - Performs tests on the Comment Based Help for public functions within the module. You shouldn't need to edit this file.
* **Integration.Exceptions.txt** - If there are specific PowerShell Script Analyser tests you wish to disable, place their names in this file. I recommend however to use the exclusions listed at the top of your functions.
* **Integration.Tests.ps1** - Tests that your module meets all PowerShell Script Analyser tests. Also tests that the module successfully loads. Place tests of the features of the module within this file.
* **Unit.Tests.ps1** - This provides a basic structure for your unit tests. Best practice is to copy this file for each function/CMDLet within the module. This structure allows for the execution of the tests for a specific function/Cmdlet.
* **Test-SingleFile.ps1** - This provides the ability to get insight in to which lines of code are covered by pester tests. See <https://www.pwsh.site/powershell/2019/01/10/how-to-enable-coverage-markings-in-vscode-for-your-powershell-projects.html> for more information.
