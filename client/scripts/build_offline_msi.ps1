Write-Host "Starting building msi..."
Set-Location $PSScriptRoot

# Run graph generate
.\generate.ps1

Set-Location $PSScriptRoot

cd..
cd..

.\server\scripts\build_dll.ps1

Set-Location $PSScriptRoot
cd..

cd apps/offline
#flutter pub get
flutter pub run msix:create `
                    --version "1.0.0.4" `
                    -c "$PSScriptRoot\sokonify.pfx" `
                    -p "#50k0n1f4" `
                    -n "sokonify_freemium" `
                    -d "Sokonify Community" `
                    -i "sokonify.freemium" `
                    -b "CN=Sokonify Software, O=Sokonify Inc, C=TZ" `
                    --install-certificate true