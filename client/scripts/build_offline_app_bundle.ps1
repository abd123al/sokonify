param(
    [int]$build_number=1,
    [string]$build_name="0.0.0.1"
)

Write-Host "Starting building app bundle"
Write-Host "build_number: $build_number"
Write-Host "build_name: $build_name"

Set-Location $PSScriptRoot

.\build_offline_android.ps1

flutter build appbundle `
--build-number=$build_number `
--build-name=$build_name `
--obfuscate `
--split-debug-info=./build/app/outputs/symbols `
--release
