. $PSScriptRoot\utils-for-test.ps1

#--------------------------------------
# Initialize
#--------------------------------------

$scriptFilename = "collect-matching-files.ps1"

$test = InitTest $MyInvocation.MyCommand.Path $scriptFilename
if ($null -eq $test) {
    Write-Host "Aborted"
    exit 0
}

#--------------------------------------
# Setup
#--------------------------------------

$gt = Join-Path -Path $test.Dir -ChildPath "gt"
$cmp = Join-Path -Path $test.Dir -ChildPath "cmp"

CreateTestFiles $gt @(
    "f01",
    "f02",
    "f03",
    "folder1\f11",
    "folder1\f12",
    "folder1\f13",
    "folder2\f21",
    "folder2\f22",
    "folder2\f23"
)

CreateTestFiles $cmp @(
    "f01",
    "f02",
    "f03",
    "f04",
    "random1\f11",
    "random1\f12",
    "random2\f13",
    "folder3\f21",
    "folder3\f22",
    "folder4\f23",
    "folder4\f24"
)

Write-Host "Test folders are set. Start testing..."

#--------------------------------------
# Invoke
#--------------------------------------

$o = Join-Path -Path $test.Dir -ChildPath "collected"
$log = Join-Path -Path $test.Dir -ChildPath "$scriptFilename.log"
& $test.scriptPath -gt $gt -cmp $cmp -o $o > $log

Write-Host "Test finished"
Write-Host "Log file is at $log"
