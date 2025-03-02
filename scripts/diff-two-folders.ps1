param ( [string]$fa, [string]$fb )

$folderA = Resolve-Path $fa
$folderB = Resolve-Path $fb

$mismatchedFiles = @{}

function Compare-Folder {
    param ( [string]$sourceFolder, [string]$targetFolder )
    Write-Output "Files only in ${sourceFolder}:"

    $sourceFiles = Get-ChildItem -Path $sourceFolder -Recurse -File
    foreach ($sourceFile in $sourceFiles) {
        $relativePath = $sourceFile.FullName.SubString($sourceFolder.Length)
        $targetFile = Join-Path -Path $targetFolder -ChildPath $relativePath

        $sourceFileSize = (Get-Item -Path $sourceFile).Length

        if (-Not (Test-Path -Path $targetFile)) {
            Write-Output "    $sourceFile"
            Write-Output "        size: $sourceFileSize bytes"
            continue
        }

        $targetFileSize = (Get-Item -Path $targetFile).Length

        if ($sourceFileSize -ne $targetFileSize) {
            $mismatchedFiles[$relativePath] += @($sourceFileSize)
        }
    }
    Write-Output ""
}

Compare-Folder -sourceFolder $folderA -targetFolder $folderB
Compare-Folder -sourceFolder $folderB -targetFolder $folderA

Write-Output "File size mismatched："
foreach ($relativePath in $mismatchedFiles.Keys) {
    $sizeInA = $mismatchedFiles[$relativePath][0]
    $sizeInB = $mismatchedFiles[$relativePath][1]
    Write-Output "    ${relativePath}:"
    Write-Output "        size(a): $sizeInA bytes"
    Write-Output "        size(b): $sizeInB bytes"
}

# Revision
#   v0.1.0: Initial commit
