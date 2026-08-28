[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$HostName,
    [int[]]$GamePort=@(30120),
    [int[]]$TxAdminPort=@(40120),
    [ValidateRange(100,30000)][int]$TimeoutMilliseconds=2000
)

$targets = @(
    $GamePort | ForEach-Object {[pscustomobject]@{Service='FiveM';Protocol='TCP';Port=$_}}
    $TxAdminPort | ForEach-Object {[pscustomobject]@{Service='txAdmin';Protocol='TCP';Port=$_}}
)

foreach ($target in $targets) {
    $client=[Net.Sockets.TcpClient]::new();$started=Get-Date;$open=$false;$errorText=$null
    try {$task=$client.ConnectAsync($HostName,$target.Port);$open=$task.Wait($TimeoutMilliseconds) -and $client.Connected;if(-not $open){$errorText='Timeout'}}
    catch {$errorText=$_.Exception.GetBaseException().Message}
    finally {$client.Dispose()}
    [pscustomobject]@{HostName=$HostName;Service=$target.Service;Protocol=$target.Protocol;Port=$target.Port;Open=$open;Milliseconds=[math]::Round(((Get-Date)-$started).TotalMilliseconds);Error=$errorText}
}
