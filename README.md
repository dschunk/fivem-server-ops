# FiveM Server Ops

A Windows-focused operations toolkit for FiveM owners who want monitoring, backups, alerts, and safer maintenance—not just another start.bat file.

| Script | Purpose |
|---|---|
| Test-FiveMEndpoint.ps1 | Check game TCP and txAdmin HTTP reachability |
| Backup-FiveMServer.ps1 | Timestamped ZIP backups with retention |
| Watch-FiveMProcess.ps1 | Detect process state changes and optionally alert Discord |
| Test-FiveMConfig.ps1 | Flag inline secrets, duplicate resources, and configuration risks |
| Get-FiveMResourceInventory.ps1 | Inventory resources, manifests, file counts, size, and modification time |
| Get-FiveMServerStatus.ps1 | Query public FiveM endpoints for player, resource, version, and latency data |
| Test-FiveMBackup.ps1 | Open, inspect, hash, and validate required files inside a ZIP backup |
| Export-FiveMStatusPage.ps1 | Convert one or more status results into sanitized status-page JSON |
| Get-FiveMLogSummary.ps1 | Classify recent errors, warnings, timeouts, disconnects, and resource activity |
| Compare-FiveMResourceSnapshot.ps1 | Compare CSV resource inventories to identify added, removed, and changed resources |
| Test-FiveMPortMatrix.ps1 | Test multiple game and txAdmin ports with service-aware results |

~~~powershell
.\Test-FiveMEndpoint.ps1 -HostName 127.0.0.1 -GamePort 30120 -TxAdminPort 40120
.\Backup-FiveMServer.ps1 -SourcePath C:\FiveM\server-data -DestinationPath D:\Backups\FiveM -RetentionDays 14
.\Watch-FiveMProcess.ps1 -ProcessName FXServer -WebhookUrl $env:DISCORD_WEBHOOK_URL
.\Test-FiveMConfig.ps1 -Path C:\FiveM\server-data\server.cfg
.\Get-FiveMResourceInventory.ps1 -ResourcesPath C:\FiveM\server-data\resources
$status = .\Get-FiveMServerStatus.ps1 -BaseUri http://127.0.0.1:30120
.\Test-FiveMBackup.ps1 -ArchivePath D:\Backups\fivem-latest.zip
.\Export-FiveMStatusPage.ps1 -ServerStatus $status -OutputPath .\status.json
.\Get-FiveMLogSummary.ps1 -Path C:\FiveM\logs\server.log
.\Compare-FiveMResourceSnapshot.ps1 -ReferencePath before.csv -DifferencePath after.csv
.\Test-FiveMPortMatrix.ps1 -HostName fivem.example.net -GamePort 30120,30121 -TxAdminPort 40120,40121
~~~

## Quality gates

[![Validate PowerShell](https://github.com/dschunk/fivem-server-ops/actions/workflows/validate-powershell.yml/badge.svg)](https://github.com/dschunk/fivem-server-ops/actions/workflows/validate-powershell.yml)

Every push and pull request is parsed on a Windows runner and checked with PSScriptAnalyzer error rules.

Store webhook URLs and server keys outside source control. Test restores—not only backup creation. Never expose txAdmin publicly without appropriate access controls.
