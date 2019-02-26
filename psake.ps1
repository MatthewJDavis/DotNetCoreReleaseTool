task default -depends AnalyseFunctions

task AnalyseFunctions {
    'Running Script Analyser on Private and Public functions'
    $privateSAResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\DotNetCoreReleaseTool\private\*.ps1 -Severity @('Error', 'Warning') -EnableExit
    $publicSAResults += Invoke-ScriptAnalyzer -Path $PSScriptRoot\DotNetCoreReleaseTool\public\*.ps1 -Severity @('Error', 'Warning') -EnableExit
    if ($privateSAResults -or $publicSAResults) {
        $privateSAResults | Format-Table
        $publicSAResults | Format-Table
        Write-Error -Message 'One or more script analyser errors/ warnings were found'
    }
}

task ModuleTest -depends AnalyseFunctions {
    'Running Module Test'
    $modTestResults = Invoke-Pester -Path $PSScriptRoot\Tests\DotNetCoreReleaseTool.Tests.ps1 -PassThru
    if ($modTestResults.FailedCount -gt 0) {
        $modTestResults | Format-Table
        Write-Error -Message 'One or more pester tests failed.'
    }
}

task UnitTest {
    'Running Unit Tests'
    $unitTestResults = Invoke-Pester -Path $PSScriptRoot\Tests\Unit -PassThru
    if ($unitTestResults.FailedCount -gt 0) {
        $unitTestResults | Format-Table
        Write-Error -Message 'One or more pester tests failed'
    }
}

task BuildPSMFile {
    'Running Build PSM File'
    exec { & .\buildPSMFile.ps1}
}

task AnalysePSMFile -depends BuildPSMFile {
    'Runnng script analyser on Script Module'
    $scriptModuleSAResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\DotNetCoreReleaseTool\DotNetCoreReleaseTool.psm1 -Severity @('Error', 'Warning') -EnableExit
    if ($scriptModuleSAResults) {
        $scriptModuleSAResults | Format-Table
        Write-Error 'One or more Script Analyser warning or errors were found.'
    }
}

task PublishModule -depends AnalyseFunctions, ModuleTest, UnitTest, BuildPSMFile, AnalysePSMFile {
    Copy-Item .\DotNetCoreReleaseTool -Destination C:\TEMP -Recurse -Force
}