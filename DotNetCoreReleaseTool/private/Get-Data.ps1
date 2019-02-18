function Get-Data {
    # Private function to return the data from the dotnet core releases json file
    param (
        $uri = 'https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json'
    )
       Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
}