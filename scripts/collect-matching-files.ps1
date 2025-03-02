param ( [string]$gt, [string]$cmp, [string]$o )

if (($gt -eq "") -or ($cmp -eq "") -or ($o -eq "")) {
    $scriptName = $MyInvocation.MyCommand.Name
    Write-Output "Usage:`r`n"
    Write-Output "    .\$scriptName -gt <gt folder> -cmp <cmp folder> -o <output folder>`r`n"
    exit 0
}

$gt = Resolve-Path $gt
$cmp = Resolve-Path $cmp

New-Item -ItemType Container -Force $o | Out-Null
$o = Resolve-Path $o

Write-Output " gt: $gt"
Write-Output "cmp: $cmp"
Write-Output ""

$gtFiles = Get-ChildItem -Path $gt -File -Recurse
$cmpFiles = Get-ChildItem -Path $cmp -File -Recurse

$operations = @()

Write-Output "Matching files:"
foreach ($cmpFile in $cmpFiles) {
    $matchingFiles = $gtFiles | Where-Object { $_.Name -eq $cmpFile.Name }
    if ($matchingFiles.Count -gt 0) {
        $firstMatchedGtFile = $matchingFiles[0]
        Write-Output "$firstMatchedGtFile"

        $dst = Join-Path -Path $o -ChildPath $firstMatchedGtFile.FullName.SubString($gt.Length)
        $operations += [PSCustomObject]@{
            Src = $cmpFile
            Dst = $dst
        }
    }
}
Write-Output ""

Write-Output "Operations:"
foreach ($operation in $operations) {
    $src = $operation.Src
    $dst = $operation.Dst
    Write-Output ""
    Write-Output "$src will be moved to:"
    Write-Output "    $dst"
}

Write-Output ""
$userInput = Read-Host "Continue? [y]"

if ($userInput -eq "y") {
    foreach ($operation in $operations) {
        $parent = Split-Path -Path $operation.Dst -Parent
        New-Item -ItemType Container -Force $parent | Out-Null
        Move-Item -Path $operation.Src -Destination $operation.Dst
    }
    Write-Output "Done"
} else {
    Write-Output "Cancelled"
}

# Revision
#   v0.1.1: Add help message
#   v0.1.0: Initial commit
