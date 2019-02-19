task default -depends Analyse

task Analyse {
    'Running analyzer'
    Invoke-ScriptAnalyzer -Path $PSScriptRoot\DotNetCoreReleaseTool\private\*.ps1 -Verbose
    Invoke-ScriptAnalyzer -Path $PSScriptRoot\DotNetCoreReleaseTool\public\*.ps1 -Verbose
}

task ModuleTest -depends Analyse {
    'Running Module Test'
    Invoke-Pester -Path $PSScriptRoot\Tests\DotNetCoreReleaseTool.Tests.ps1
}

task UnitTest {
    'Running Unit Tests'
    Invoke-Pester -Path $PSScriptRoot\Tests\Unit
}

task BuildPSMFile {
    'Running Build PSM File'
    exec { & .\buildPSMFile.ps1}
}

task AnalysePSMFile {
    Invoke-ScriptAnalyzer -Path $PSScriptRoot\DotNetCoreReleaseTool\DotNetCoreReleaseTool.psm1
}