[CmdletBinding()]
param([Parameter(Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string]$Path)

$lines=Get-Content -LiteralPath $Path
$findings=[Collections.Generic.List[object]]::new()
function Add-Finding($Severity,$Line,$Message){$findings.Add([pscustomobject]@{Severity=$Severity;Line=$Line;Message=$Message})}

for($i=0;$i -lt $lines.Count;$i++){
    $line=$lines[$i].Trim(); $number=$i+1
    if($line -match 'sv_licenseKey\s+["'']?[^$%{]') {Add-Finding 'Critical' $number 'A license key appears to be committed directly. Use an environment variable or protected deployment configuration.'}
    if($line -match '(password|token|secret|webhook).*=\s*["''][^$%{]') {Add-Finding 'Critical' $number 'A possible secret appears inline.'}
    if($line -match '^ensure\s+(.+)$'){
        $resource=$Matches[1].Trim()
        $duplicates=($lines|Where-Object {$_.Trim() -eq "ensure $resource"}).Count
        if($duplicates -gt 1){Add-Finding 'Warning' $number "Resource '$resource' is ensured more than once."}
    }
    if($line -match '^endpoint_add_(tcp|udp)\s+"?0\.0\.0\.0:(\d+)') {Add-Finding 'Info' $number "Public listener configured on port $($Matches[2]); confirm firewall and exposure."}
}

if(-not ($lines -match '^sv_scriptHookAllowed\s+0')){Add-Finding 'Warning' 0 'sv_scriptHookAllowed 0 was not found.'}
if(-not ($lines -match '^sets\s+sv_projectName')){Add-Finding 'Info' 0 'No sv_projectName metadata was found.'}
$findings | Sort-Object @{Expression={switch($_.Severity){'Critical'{0}'Warning'{1}default{2}}}},Line
