[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][ValidateScript({Test-Path -LiteralPath $_ -PathType Container})][string]$SourcePath,
    [Parameter(Mandatory)][string]$DestinationPath,
    [ValidateRange(1,3650)][int]$RetentionDays = 14
)

if (-not (Test-Path -LiteralPath $DestinationPath)) { New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null }
$archivePath = Join-Path $DestinationPath ("fivem-backup-{0}.zip" -f (Get-Date -Format "yyyyMMdd-HHmmss"))

if ($PSCmdlet.ShouldProcess($SourcePath,"Create backup $archivePath")) {
    Compress-Archive -Path (Join-Path $SourcePath "*") -DestinationPath $archivePath -CompressionLevel Optimal
    Get-Item $archivePath | Select-Object FullName,@{Name="SizeMB";Expression={[math]::Round($_.Length/1MB,2)}},CreationTime
    $cutoff=(Get-Date).AddDays(-1*$RetentionDays)
    Get-ChildItem $DestinationPath -Filter "fivem-backup-*.zip" -File | Where-Object LastWriteTime -lt $cutoff | ForEach-Object {
        if ($PSCmdlet.ShouldProcess($_.FullName,"Remove expired backup")) { Remove-Item $_.FullName -Force }
    }
}
