function Get-DNCLatestVersion {
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        $MajorVersion = '2',
        $MinorVersion
    )

    begin {
    }

    process {

        if ($PSBoundParameters.ContainsKey('MinorVersion')) {
            $version = "$MajorVersion.$MinorVersion*"
        } else {
            $version = "$MajorVersion*"
        }


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