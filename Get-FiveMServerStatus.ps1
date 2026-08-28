[CmdletBinding()]
param(
    [Parameter(Mandatory)][uri]$BaseUri,
    [ValidateRange(1,30)][int]$TimeoutSeconds = 5
)

$base = $BaseUri.AbsoluteUri.TrimEnd('/')
$started = Get-Date
try {
    $dynamic = Invoke-RestMethod -Uri "$base/dynamic.json" -TimeoutSec $TimeoutSeconds -ErrorAction Stop
    $players = @(Invoke-RestMethod -Uri "$base/players.json" -TimeoutSec $TimeoutSeconds -ErrorAction Stop)
    $info = Invoke-RestMethod -Uri "$base/info.json" -TimeoutSec $TimeoutSeconds -ErrorAction Stop

    [pscustomobject]@{
        Online = $true
        Hostname = $dynamic.hostname
        Players = $players.Count
        MaxPlayers = $dynamic.sv_maxclients
        GameType = $dynamic.gametype
        MapName = $dynamic.mapname
        Resources = @($info.resources).Count
        ServerVersion = $info.server
        ResponseMilliseconds = [math]::Round(((Get-Date) - $started).TotalMilliseconds)
        CheckedAt = Get-Date
        Error = $null
    }
} catch {
    [pscustomobject]@{
        Online = $false; Hostname = $null; Players = $null; MaxPlayers = $null
        GameType = $null; MapName = $null; Resources = $null; ServerVersion = $null
        ResponseMilliseconds = [math]::Round(((Get-Date) - $started).TotalMilliseconds)
        CheckedAt = Get-Date; Error = $_.Exception.GetBaseException().Message
    }
}
