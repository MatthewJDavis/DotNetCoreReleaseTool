# Get the function from the Public directory and dot source it for testing against.
# Dot source the private function Get-Data

$moduleName = "DotNetCoreReleaseTool"

if (Get-Module -Name $moduleName) {
    Remove-Module -Name $moduleName -Force
}

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$PublicRoot = Resolve-Path "$projectRoot\*\Public"
$PrivateRoot = Resolve-Path "$projectRoot\*\Private"

. $PublicRoot\Get-DNCLatestVersion.ps1
. $PrivateRoot\Get-Data.ps1

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
        it "returns version 2.2 when major version 2 in input and no minor version is specified" {
            $latest = Get-DNCLatestVersion -MajorVersion 2
            $latest.versionRuntime -like "2.2*" | Should Be $true
        }
        Mock Get-Data -MockWith { [PSCustomObject]@{
                'version-runtime' = '3.2'
                'version-sdk'     = '3.2.104'
                'date'            = '2019-02-18'
                'lts-runtime'     = 'false'
                'lts-sdk'         = 'false'
            }
        }
        it "returns version 3.2 when Major version 3 input and no minor version is specified" {
            $latest = Get-DNCLatestVersion -MajorVersion 3
            $latest.versionRuntime -like "3.2*" | Should Be $true
        }
    }

}