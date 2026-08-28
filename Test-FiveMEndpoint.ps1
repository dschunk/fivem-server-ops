[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$HostName,
    [ValidateRange(1,65535)][int]$GamePort = 30120,
    [ValidateRange(1,65535)][int]$TxAdminPort = 40120,
    [ValidateRange(1,30)][int]$TimeoutSeconds = 5
)

function Test-TcpPort([string]$Target,[int]$Port,[int]$Timeout) {
    $client = [System.Net.Sockets.TcpClient]::new()
    try { $task = $client.ConnectAsync($Target,$Port); return $task.Wait([TimeSpan]::FromSeconds($Timeout)) -and $client.Connected }
    catch { return $false } finally { $client.Dispose() }
}

$status = $null
try {
    $response = Invoke-WebRequest -Uri "http://${HostName}:$TxAdminPort/" -Method Head -TimeoutSec $TimeoutSeconds -UseBasicParsing -ErrorAction Stop
    $status = $response.StatusCode
} catch { if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode } }

[pscustomobject]@{
    HostName=$HostName; CheckedAt=Get-Date; GamePort=$GamePort
    GameTcpReachable=Test-TcpPort $HostName $GamePort $TimeoutSeconds
    TxAdminPort=$TxAdminPort; TxAdminHttpStatus=$status; TxAdminResponding=$null -ne $status
}
