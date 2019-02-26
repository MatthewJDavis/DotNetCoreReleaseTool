function Get-Data {
    # Private function to return the data from the dotnet core releases json file
    param (
        $uri = 'https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json'
    )
    Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
}
function Get-DNCLatestVersion {
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        $MajorVersion = '2',
        $MinorVersion = '2'
    )

    begin {
    }

    process {
        $version = "$MajorVersion.$MinorVersion*"
        $data = Get-Data
        $latestRelease = $data | Where-Object {$_.'version-runtime' -like $version} | Select-Object -First 1
        [pscustomobject]@{
            ReleaseDate    = $latestRelease.date
            VersionRuntime = $latestRelease.'version-runtime'
            VersionSdk     = $latestRelease.'version-sdk'
            LtsRuntime     = $latestRelease.'lts-runtime'
            LtsSdk         = $latestRelease.'lts-sdk'
        }


    }

    end {
    }
}
Export-ModuleMember -Function Get-DNCLatestVersion
