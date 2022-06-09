Write-Host "Running..."
Set-Location $PSScriptRoot
cd..
cd apps/online

$ipv4 = (Test-Connection -ComputerName (hostname) -Count 1 | Select -ExpandProperty IPv4Address).IPAddressToString
$baseUrl = "http://$($ipv4):9191"
$baseUrl

flutter run --dart-define BASE_URL=$baseUrl

Write-Host "Done gerenerating graph code!"