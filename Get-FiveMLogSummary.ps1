[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$Path,
    [ValidateRange(100,1000000)][int]$Tail = 10000
)

$lines = Get-Content -LiteralPath $Path -Tail $Tail
$patterns = [ordered]@{
    Error = '(?i)\b(error|exception|failed|fatal)\b'
    Warning = '(?i)\bwarn(ing)?\b'
    Timeout = '(?i)\btime(d)?\s*out\b'
    Disconnect = '(?i)\b(disconnect(ed)?|connection reset)\b'
    Resource = '(?i)\b(started|stopped|ensure) resource\b'
}

foreach ($category in $patterns.Keys) {
    $matches = @($lines | Select-String -Pattern $patterns[$category])
    [pscustomobject]@{
        Category=$category;Count=$matches.Count
        LatestSample=($matches | Select-Object -Last 1).Line
    }
}
