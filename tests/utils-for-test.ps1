function InitTest {
    param (
        [Parameter(Mandatory=$true, Position=0)] [string]$testScriptPath,
        [Parameter(Mandatory=$true, Position=1)] [string]$scriptFilename
    )

    # Create testsRoot and logsRoot directory
    $testsRoot = "$PSScriptRoot\..\tmp"
    if (-not (Test-Path -Path $testsRoot)) {
        New-Item -ItemType Container -Path $testsRoot | Out-Null
    }
    $testsRoot = Resolve-Path $testsRoot

    # Create global variables for this test
    $testName = [System.IO.Path]::GetFileNameWithoutExtension($testScriptPath)
    $test = [PSCustomObject]@{
        Name       = $testName
        Dir        = Join-Path -Path $testsRoot -ChildPath $testName
        ScriptPath = Resolve-Path ("$PSScriptRoot\..\scripts\" + $scriptFilename)
    }
    Write-Host ("Name:        " + $test.Name)
    Write-Host ("Script:      " + $test.ScriptPath)
    Write-Host ("Test script: " + $testScriptPath)
    Write-Host ("Test dir:    " + $test.Dir)

    # Cleanup testDir
    if (Test-Path -Path $test.Dir) {
        Write-Host ("WARNING: Will completely delete " + $test.Dir)
        $userInput = Read-Host "Continue? [y]"
        if ($userInput -ne 'y') {
            return $null
        }
        Remove-Item -Recurse -Force -Path $test.Dir | Out-Null
    }
    New-Item -ItemType Container -Path $test.Dir -Force | Out-Null
    return $test
}

function CreateTestFiles {
    param (
        [Parameter(Mandatory=$true, Position=0)] [string]$dir,
        [Parameter(Mandatory=$true, Position=1)] [string[]]$files
    )

    foreach ($file in $files) {
        $file = Join-Path -Path $dir -ChildPath $file
        New-Item -ItemType File -Path $file -Force | Out-Null
        Set-Content -Path $file -Value $file
    }
}
