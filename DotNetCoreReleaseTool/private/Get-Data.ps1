function Get-Data {
    param (
        $uri = 'https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json'
    )
    $data = Invoke-RestMethod -Uri $uri -Method Get 

    Return $data
}