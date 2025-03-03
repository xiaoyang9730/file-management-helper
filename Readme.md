# diff-two-folders

```
.\scripts\diff-two-folders.ps1 `
    -fa .\tests\diff-two-folders\folder1 `
    -fb .\tests\diff-two-folders\folder2 `
    > .\tests\logs\diff-two-folders.log

.\scripts\diff-two-folders.ps1 `
    -fa .\tests\diff-two-folders\folder1 `
    -fb .\tests\diff-two-folders\folder2 `
    -aOnly `
    > .\tests\logs\diff-two-folders_aonly.log
```

# collect-matching-files

```
.\tests\collect-matching-files\setup-test.ps1
```

```
.\scripts\collect-matching-files.ps1 `
    -gt .\tests\collect-matching-files\gt `
    -cmp .\tests\collect-matching-files\cmp `
    -o .\tests\collect-matching-files\o `
    > .\tests\logs\collect-matching-files.log
```
