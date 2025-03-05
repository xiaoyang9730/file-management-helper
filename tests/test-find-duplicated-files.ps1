. $PSScriptRoot\utils-for-test.ps1

#--------------------------------------
# Initialize
#--------------------------------------

$scriptFilename = "find-duplicated-files.ps1"

$test = InitTest $MyInvocation.MyCommand.Path $scriptFilename
if ($null -eq $test) {
    Write-Host "Aborted"
    exit 0
}

#--------------------------------------
# Setup
#--------------------------------------

$dir = Join-Path -Path $test.Dir -ChildPath "dir"

$files = @(
    "f01",
    "f02",
    "f03",
    "folder1\f01",
    "folder1\f11",
    "folder1\f12",
    "folder1\f13",
    "folder2\f01",
    "folder2\f02",
    "folder2\f21",
    "folder2\f22",
    "folder2\f23"
)

CreateTestFiles $dir $files

#--------------------------------------
# Invoke
#--------------------------------------

$log = Join-Path -Path $test.Dir -ChildPath "$scriptFilename.log"
& $test.scriptPath $dir > $log

Write-Host "Test finished"
Write-Host "Log file is at $log"
