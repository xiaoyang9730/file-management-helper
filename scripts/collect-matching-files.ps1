param (
    [Parameter(Mandatory=$true)]
    [Alias("r")]
    [string]$Reference,

    [Parameter(Mandatory=$true)]
    [Alias("t")]
    [string]$Target,

    [Parameter(Mandatory=$false)]
    [Alias("o")]
    [string]$Output = "$Target\Collected",

    [Parameter(Mandatory=$false)]
    [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512", "MACTripleDES", "MD5")]
    [string]$HashAlgorithm = "MD5"
)

$version = "v0.2.0"

New-Item -ItemType Container -Force $Output | Out-Null

$Reference = Resolve-Path $Reference
$Target = Resolve-Path $Target
$Output = Resolve-Path $Output

Write-Output "Version: $version"
Write-Output "Reference:"
Write-Output "    $Reference"
Write-Output "Target:"
Write-Output "    $Target"
Write-Output "Output:"
Write-Output "    $Output"

$referencePaths = @{}

Get-ChildItem -Recurse -File -Path $Reference | ForEach-Object {
    $hash = (Get-FileHash -Path $_ -Algorithm $HashAlgorithm).Hash
    if (-not $referencePaths.ContainsKey($hash)) {
        $referencePaths[$hash] = $_.FullName
    }
}

$operations = @()
Write-Output "Operations planned:"
Get-ChildItem -Recurse -File -Path $Target | ForEach-Object {
    $hash = (Get-FileHash -Path $_ -Algorithm $HashAlgorithm).Hash
    if ($referencePaths.ContainsKey($hash)) {
        $destination = Join-Path -Path $Output -ChildPath $referencePaths[$hash].SubString($Output.Length)
        $operations += [PSCustomObject]@{
            From = $_
            To = $destination
        }
        Write-Output ("    From: $_")
        Write-Output ("    To:   $destination")
    }
}

if ("y" -ne (Read-Host "Start collecting? [y]")) {
    Write-Output "Aborted"
    exit 0
}


$moved = @()
$skipped = @()

$operations | ForEach-Object {
    if (Test-Path $_.To) {
        $skipped += $_.From
    } else {
        $parent = Split-Path $_.To -Parent
        if (-not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Move-Item -Path $_.From -Destination $_.To
        $moved += $_.From
    }
}

Write-Output "Moved files:"
$moved | ForEach-Object {
    Write-Output "    $_"
}
Write-Output "Skipped files:"
$skipped | ForEach-Object {
    Write-Output "    $_"
}

Write-Output "Done"

# Revision
#   v0.2.0: Improve file comparison using hash, and log skipped files for a second round collection
#   v0.1.1: Add help message
#   v0.1.0: Initial commit
