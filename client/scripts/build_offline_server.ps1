Set-PSDebug -Trace 1
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
flutter build windows `
                    --dart-define PORT=9191 `
                    --dart-define IS_SERVER=true --obfuscate `
                    --split-debug-info=./build/app/outputs/symbols `
                    --release

flutter pub run msix:create `
                    --version "1.0.0.11" `
                    --install-certificate true `
                    --build-windows false `
                    -c "$PSScriptRoot\sokonify_server.pfx" `
                    -p "#50k0n1f4" `
                    -n "sokonify_server" `
                    -d "Sokonify Server" `
                    -i "sokonify.server" `
                    -b "CN=Sokonify Software, O=Sokonify Inc, C=TZ"