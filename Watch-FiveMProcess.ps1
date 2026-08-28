[CmdletBinding()]
param(
    [string]$ProcessName="FXServer",
    [string]$WebhookUrl,
    [string]$StateFile=(Join-Path $env:TEMP "fivem-process-state.json")
)

$running=$null -ne (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
$previous=$null
if (Test-Path $StateFile) { try { $previous=(Get-Content $StateFile -Raw|ConvertFrom-Json).Running } catch {} }
@{Running=$running;CheckedAt=(Get-Date).ToString("o")}|ConvertTo-Json|Set-Content $StateFile -Encoding UTF8
$changed=$null -ne $previous -and $previous -ne $running
[pscustomobject]@{ProcessName=$ProcessName;Running=$running;Changed=$changed;CheckedAt=Get-Date}

if ($changed -and $WebhookUrl) {
    $state=if($running){"ONLINE"}else{"OFFLINE"}
    $payload=@{username="FiveM Operations";content="FiveM process $ProcessName changed state: **$state** on $env:COMPUTERNAME."}|ConvertTo-Json
    Invoke-RestMethod -Uri $WebhookUrl -Method Post -ContentType "application/json" -Body $payload
}
