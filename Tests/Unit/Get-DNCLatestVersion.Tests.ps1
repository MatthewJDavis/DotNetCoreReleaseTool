# Get the function from the Public directory and dot source it for testing against
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$PublicRoot = Resolve-Path "$projectRoot\*\Public"
. $PublicRoot\Get-DNCLatestVersion.ps1

InModuleScope DotNetCoreReleaseTool {
    Describe 'Get-DNCLatestVersion' {
        $cmdlet = Get-Command Get-DNCLatestVersion 
        Context 'Cmdlet' {
            it "Has an output of a PSCustomObject" {
                $cmdlet.OutputType.Name -eq 'PSCustomObject' | Should Be $true 
            }
        }
        Context 'Output' {
            Mock Get-Data -MockWith { [PSCustomObject]@{ 
                    'version-runtime' = '2.2'
                    'version-sdk'     = '2.2.104'
                    'date'            = '2019-02-18'
                    'lts-runtime'     = 'false'
                    'lts-sdk'         = 'false'   
                } 
            } 
            it "returns version 2.2 when no major or minor version is specified" {
                $latest = Get-DNCLatestVersion
                $latest.versionRuntime -like "2.2*" | Should Be $true
            }
        }
    }
}