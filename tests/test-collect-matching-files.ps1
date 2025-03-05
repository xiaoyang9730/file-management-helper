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

$Reference = Join-Path -Path $test.Dir -ChildPath "Reference"
$Target = Join-Path -Path $test.Dir -ChildPath "Target"

CreateTestFiles $Reference @(
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

CreateTestFiles $Target @(
    "f01",
    "f02",
    "f03",
    "f04",
    "v1\random\f11",
    "v1\random\f12",
    "v1\random\f13",
    "v2\random\f11",
    "v2\random\f12",
    "v2\random\f13",
    "v3\random\f11",
    "v3\random\f12",
    "v3\random\f13",
    "v4\random\f11",
    "v4\random\f12",
    "v4\random\f13"
)

Write-Host "Test folders are set. Start testing..."

#--------------------------------------
# Invoke
#--------------------------------------

$Output = Join-Path -Path $test.Dir -ChildPath "Collected"
$logPath = Join-Path -Path $test.Dir -ChildPath "$scriptFilename.log"
& $test.scriptPath -Reference $Reference -Target $Target -Output $Output > $logPath

Write-Host "Test finished"
Write-Host "Log file is at $logPath"
