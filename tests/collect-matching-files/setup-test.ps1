$gt = Join-Path -Path $PSScriptRoot -ChildPath "gt"
$cmp = Join-Path -Path $PSScriptRoot -ChildPath "cmp"
$o = Join-Path -Path $PSScriptRoot -ChildPath "o"

Remove-Item -Recurse -Force -Path $gt
Remove-Item -Recurse -Force -Path $cmp
Remove-Item -Recurse -Force -Path $o

$gtFiles = @(
    ".\f01"     , ".\f02"     , ".\f03"     ,
    ".\sub1\f11", ".\sub1\f12", ".\sub1\f13",
    ".\sub2\f21", ".\sub2\f22", ".\sub2\f23"
)
foreach ($gtFile in $gtFiles) {
    $gtFile = Join-Path -Path $gt -ChildPath $gtFile
    New-Item -ItemType File -Path $gtFile -Force | Out-Null
}

$cmpFiles = @(
    "f01", "f02", "f03", "f04",
    ".\folder\f11", ".\folder\f12",
    "f21"
)
foreach ($cmpFile in $cmpFiles) {
    $cmpFile = Join-Path -Path $cmp -ChildPath $cmpFile
    New-Item -ItemType File -Path $cmpFile -Force | Out-Null
}

Write-Output "Test folders are set"
