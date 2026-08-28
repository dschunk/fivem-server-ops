[CmdletBinding()]
param(
    [Parameter(Mandatory)][psobject[]]$ServerStatus,
    [Parameter(Mandatory)][string]$OutputPath
)

$payload = [ordered]@{
    generatedAt = (Get-Date).ToUniversalTime().ToString('o')
    overall = if ($ServerStatus.Online -contains $false) {'degraded'} else {'operational'}
    servers = @($ServerStatus | ForEach-Object {
        [ordered]@{
            name = $_.Hostname
            online = [bool]$_.Online
            players = $_.Players
            maxPlayers = $_.MaxPlayers
            responseMilliseconds = $_.ResponseMilliseconds
            checkedAt = $_.CheckedAt
        }
    })
}

$payload | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Get-Item -LiteralPath $OutputPath
