[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$ArchivePath,
    [string[]]$RequiredEntry = @('server.cfg'),
    [ValidateSet('SHA256','SHA384','SHA512')][string]$HashAlgorithm = 'SHA256'
)

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = $null
try {
    $archive = [IO.Compression.ZipFile]::OpenRead((Resolve-Path $ArchivePath))
    $entries = @($archive.Entries | Where-Object {-not [string]::IsNullOrEmpty($_.Name)} | Select-Object -ExpandProperty FullName)
    $missing = foreach ($required in $RequiredEntry) {
        if (-not ($entries | Where-Object {$_ -like "*$required"})) {$required}
    }
    $file = Get-Item -LiteralPath $ArchivePath
    [pscustomobject]@{
        ArchivePath = $file.FullName
        ValidZip = $true
        EntryCount = $entries.Count
        SizeMB = [math]::Round($file.Length / 1MB,2)
        RequiredEntriesPresent = @($missing).Count -eq 0
        MissingEntries = @($missing)
        HashAlgorithm = $HashAlgorithm
        Hash = (Get-FileHash -LiteralPath $ArchivePath -Algorithm $HashAlgorithm).Hash
        TestedAt = Get-Date
        Error = $null
    }
} catch {
    [pscustomobject]@{ArchivePath=$ArchivePath;ValidZip=$false;EntryCount=$null;SizeMB=$null;RequiredEntriesPresent=$false;MissingEntries=@();HashAlgorithm=$HashAlgorithm;Hash=$null;TestedAt=Get-Date;Error=$_.Exception.GetBaseException().Message}
} finally {
    if ($archive) {$archive.Dispose()}
}
