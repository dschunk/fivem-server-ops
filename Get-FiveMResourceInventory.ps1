[CmdletBinding()]
param([Parameter(Mandatory)][ValidateScript({Test-Path $_ -PathType Container})][string]$ResourcesPath)

Get-ChildItem -LiteralPath $ResourcesPath -Directory -Recurse | Where-Object {
    Test-Path (Join-Path $_.FullName 'fxmanifest.lua') -PathType Leaf -or Test-Path (Join-Path $_.FullName '__resource.lua') -PathType Leaf
} | ForEach-Object {
    $manifest=if(Test-Path (Join-Path $_.FullName 'fxmanifest.lua')){Join-Path $_.FullName 'fxmanifest.lua'}else{Join-Path $_.FullName '__resource.lua'}
    $files=Get-ChildItem -LiteralPath $_.FullName -File -Recurse -ErrorAction SilentlyContinue
    [pscustomobject]@{
        Resource=$_.Name
        RelativePath=$_.FullName.Substring((Resolve-Path $ResourcesPath).Path.Length).TrimStart('\')
        Manifest=(Split-Path $manifest -Leaf)
        Files=$files.Count
        SizeMB=[math]::Round(($files|Measure-Object Length -Sum).Sum/1MB,2)
        LastModified=($files|Sort-Object LastWriteTime -Descending|Select-Object -First 1).LastWriteTime
    }
} | Sort-Object Resource
