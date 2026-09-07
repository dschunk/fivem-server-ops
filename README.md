# FiveM Server Ops

> **Personal project notice:** This repository is maintained in a personal capacity and is not affiliated with, sponsored by, or endorsed by any current or former employer. Do not contribute employer confidential or proprietary information, non-public internal configurations, customer data, credentials, or employer work product. Examples should use personal/community infrastructure or generic test data.

A specialized Windows operations toolkit for FiveM server owners who want the same habits that matter in ordinary infrastructure: monitoring, validated backups, configuration review, logging, inventory, status reporting, and visible failure.

This is intentionally an **operations project**, not a gameplay framework or server pack.

## Tool catalog

| Script | Purpose |
|---|---|
| `Test-FiveMEndpoint.ps1` | Check game TCP and txAdmin HTTP reachability |
| `Backup-FiveMServer.ps1` | Create timestamped ZIP backups with retention |
| `Watch-FiveMProcess.ps1` | Detect process-state changes and optionally alert Discord |
| `Test-FiveMConfig.ps1` | Flag inline secrets, duplicate resources, and configuration risks |
| `Get-FiveMResourceInventory.ps1` | Inventory resources, manifests, file counts, size, and modification time |
| `Get-FiveMServerStatus.ps1` | Query public endpoints for player, resource, version, and latency data |
| `Test-FiveMBackup.ps1` | Open, inspect, hash, and validate required files inside a ZIP backup |
| `Export-FiveMStatusPage.ps1` | Convert status results into sanitized status-page JSON |
| `Get-FiveMLogSummary.ps1` | Classify recent errors, warnings, timeouts, disconnects, and resource activity |
| `Compare-FiveMResourceSnapshot.ps1` | Identify added, removed, and changed resources between inventories |
| `Test-FiveMPortMatrix.ps1` | Test multiple game and txAdmin ports with service-aware results |

## Example workflow

```powershell
# Is the service reachable?
.\Test-FiveMEndpoint.ps1 -HostName 127.0.0.1 -GamePort 30120 -TxAdminPort 40120

# Is the configuration safe to commit or deploy?
.\Test-FiveMConfig.ps1 -Path C:\FiveM\server-data\server.cfg

# What resources are actually installed?
.\Get-FiveMResourceInventory.ps1 -ResourcesPath C:\FiveM\server-data\resources

# Create and then validate a backup
.\Backup-FiveMServer.ps1 `
    -SourcePath C:\FiveM\server-data `
    -DestinationPath D:\Backups\FiveM `
    -RetentionDays 14

.\Test-FiveMBackup.ps1 -ArchivePath D:\Backups\fivem-latest.zip

# Summarize operational noise
.\Get-FiveMLogSummary.ps1 -Path C:\FiveM\logs\server.log
```

## Operational rules

- **Do not store server keys or webhook URLs in source control.** Use environment variables or another protected secret store.
- **A successful backup job is not proof of recoverability.** Validate archives and test restores.
- **Do not expose txAdmin directly to the public internet without appropriate access controls.**
- **Monitor state changes, not just current state.** An alert is more useful when it explains what changed.
- **Sanitize public status data.** Internal hostnames, administrative ports, paths, secrets, and private infrastructure details do not belong on a public status page.
- **Collect before changing.** Logs and configuration snapshots are easiest to interpret before someone starts experimenting.

## Quality gates

[![Validate PowerShell](https://github.com/dschunk/fivem-server-ops/actions/workflows/validate-powershell.yml/badge.svg)](https://github.com/dschunk/fivem-server-ops/actions/workflows/validate-powershell.yml)

Every push and pull request is parsed on a Windows runner and checked with PSScriptAnalyzer error rules.

## Related engineering work

This repository is a specialized branch of the same operational philosophy used across the broader portfolio:

- [Windows IT Toolkit / SchunkOps](https://github.com/dschunk/windows-it-toolkit) — general Windows and infrastructure operations tooling
- [Infrastructure Dashboard](https://github.com/dschunk/infrastructure-dashboard) — public operations-interface case study
- [Build It Like You Won't Be There Tomorrow](https://github.com/dschunk/build-it-like-you-wont-be-there) — runbooks, monitoring, backup, recovery, and handoff standards
- [Everyday IT Tips](https://everydayittips.com/) — practical Windows and infrastructure field guides
- [DavidSchunk.com](https://www.davidschunk.com/) — broader portfolio
