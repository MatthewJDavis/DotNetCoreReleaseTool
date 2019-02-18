task default -depends Analyse

task Analyse {
    'Running analyzer'
    Invoke-ScriptAnalyzer -Path .\DotNetCoreReleaseTool\private\Get-Data.ps1 -Verbose
}

task ModuleTest {
    'Running Module Test'
    Invoke-Pester -Path $PSScriptRoot\Tests
}

task UnitTest {
    'Running Unit Tests'
    Invoke-Pester -Path $PSScriptRoot\Tests\Unit
}