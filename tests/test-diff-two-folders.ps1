. $PSScriptRoot\utils-for-test.ps1

#--------------------------------------
# Initialize
#--------------------------------------

$scriptFilename = "diff-two-folders.ps1"

$test = InitTest $MyInvocation.MyCommand.Path $scriptFilename
if ($null -eq $test) {
    Write-Host "Aborted"
    exit 0
}

#--------------------------------------
# Setup
#--------------------------------------

$fa = Join-Path -Path $test.Dir -ChildPath "fa"
$fb = Join-Path -Path $test.Dir -ChildPath "fb"

# Files definition

$commonFiles = @(
    "common_01",
    "common_02",
    "common_03",
    "folder_1\common_11",
    "folder_1\common_12",
    "folder_1\common_13",
    "folder_2\common_21",
    "folder_2\common_22",
    "folder_2\common_23"
)
$faOnlyFiles = @(
    "fa_only_01",
    "folder_1\fa_only_11",
    "folder_2\fa_only_21"
)
$fbOnlyFiles = @(
    "fb_only_01",
    "folder_1\fb_only_11",
    "folder_2\fb_only_21"
)
$faTimeChangedFiles = @(
    "fa_time_01",
    "folder_1\fa_time_11",
    "folder_2\fa_time_21"
)
$fbTimeChangedFiles = @(
    "fb_time_01",
    "folder_1\fb_time_11",
    "folder_2\fb_time_21"
)
$faContentChangedFiles = @(
    "fa_content_01",
    "folder_1\fa_content_11",
    "folder_2\fa_content_21"
)
$fbContentChangedFiles = @(
    "fb_content_01",
    "folder_1\fb_content_11",
    "folder_2\fb_content_21"
)

# Create common files

CreateTestFiles $fa ($commonFiles + $faTimeChangedFiles + $fbTimeChangedFiles + $faContentChangedFiles + $fbContentChangedFiles)
Copy-Item -Path $fa -Destination $fb -Recurse

# Create exclusive files

CreateTestFiles $fa $faOnlyFiles
CreateTestFiles $fb $fbOnlyFiles

# Change files

Start-Sleep -Seconds 2

CreateTestFiles $fa $faTimeChangedFiles
CreateTestFiles $fb $fbTimeChangedFiles

foreach ($file in $faContentChangedFiles) {
    $file = Join-Path -Path $fa -ChildPath $file
    Add-Content -Path $file -Value "Modified"
}
foreach ($file in $fbContentChangedFiles) {
    $file = Join-Path -Path $fb -ChildPath $file
    Add-Content -Path $file -Value "Modified"
}

Write-Host "Test folders are set. Start testing..."

#--------------------------------------
# Invoke
#--------------------------------------

$logPath = Join-Path -Path $test.Dir -ChildPath "$scriptFilename.log"
& $test.scriptPath -fa $fa -fb $fb > $logPath

Write-Host "Test finished"
Write-Host "Log file is at $logPath"
