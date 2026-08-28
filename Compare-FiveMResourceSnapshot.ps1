[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$ReferencePath,
    [Parameter(Mandatory)][ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$DifferencePath
)

$before = @(Import-Csv -LiteralPath $ReferencePath)
$after = @(Import-Csv -LiteralPath $DifferencePath)
$beforeMap = @{}; $afterMap = @{}
$before | ForEach-Object {$beforeMap[$_.Resource]=$_}
$after | ForEach-Object {$afterMap[$_.Resource]=$_}

foreach ($name in @($beforeMap.Keys + $afterMap.Keys | Sort-Object -Unique)) {
    $old=$beforeMap[$name]; $new=$afterMap[$name]
    $state = if(-not $old){'Added'}elseif(-not $new){'Removed'}elseif($old.SizeMB -ne $new.SizeMB -or $old.Files -ne $new.Files){'Changed'}else{'Unchanged'}
    [pscustomobject]@{Resource=$name;State=$state;OldFiles=$old.Files;NewFiles=$new.Files;OldSizeMB=$old.SizeMB;NewSizeMB=$new.SizeMB}
}
