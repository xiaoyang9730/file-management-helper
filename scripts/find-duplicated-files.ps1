param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$dir
)

if ([string]::IsNullOrEmpty($dir)) {
    $scriptName = $MyInvocation.MyCommand.Name
    Write-Output "Usage:`r`n"
    Write-Output "    .\$scriptName <folder>`r`n"
    exit 0
}

$existingFiles = @{}

$files = Get-ChildItem -Path $dir -Recurse -File
foreach ($file in $files) {
    $hash = Get-FileHash -Path $file -Algorithm MD5
    if ($existingFiles.ContainsKey($hash.Hash)) {
        $existingFiles[$hash.Hash] += $file.ToString()
    } else {
        $existingFiles[$hash.Hash] = @($file.ToString())
    }
}

foreach ($filehash in $existingFiles.Keys) {
    if ($existingFiles[$filehash].Length -gt 1) {
        Write-Output "---"
        foreach ($filepath in $existingFiles[$filehash]) {
            Write-Output "$filepath"
        }
    }
}

# Revision
#   v0.1.0: Initial commit
