# FiveM Server Ops

A Windows-focused operations toolkit for FiveM owners who want monitoring, backups, alerts, and safer maintenance—not just another start.bat file.

| Script | Purpose |
|---|---|
| Test-FiveMEndpoint.ps1 | Check game TCP and txAdmin HTTP reachability |
| Backup-FiveMServer.ps1 | Timestamped ZIP backups with retention |
| Watch-FiveMProcess.ps1 | Detect process state changes and optionally alert Discord |

~~~powershell
.\Test-FiveMEndpoint.ps1 -HostName 127.0.0.1 -GamePort 30120 -TxAdminPort 40120
.\Backup-FiveMServer.ps1 -SourcePath C:\FiveM\server-data -DestinationPath D:\Backups\FiveM -RetentionDays 14
.\Watch-FiveMProcess.ps1 -ProcessName FXServer -WebhookUrl $env:DISCORD_WEBHOOK_URL
~~~

Store webhook URLs and server keys outside source control. Test restores—not only backup creation. Never expose txAdmin publicly without appropriate access controls.
