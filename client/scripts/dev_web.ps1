Write-Host "Running web..."
Set-Location $PSScriptRoot
cd..
cd apps/online

flutter run -d chrome --web-port=8181

Write-Host "Done building web"