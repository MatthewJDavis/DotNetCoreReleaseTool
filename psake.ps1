task default -depends Analyse

task Analyse {
    'Running analyzer'
    Invoke-ScriptAnalyzer -Path .\DotNetCoreReleaseTool\private\Get-Data.ps1 -Verbose
}