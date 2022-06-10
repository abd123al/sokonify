param(
    [string]$destination="..\..\server\web\"
)

Write-Host "destination: $destination"

Set-Location $PSScriptRoot
cd..
cd apps/online
flutter build web

Set-Location $PSScriptRoot
Copy-Item -Path "..\apps\online\build\web\" -Destination $destination -Recurse -Force
Write-Host "Done copying"