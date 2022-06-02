Write-Host "Type certificate name below"
$name = Read-Host "Certificate Name"

Set-Location $PSScriptRoot

$certificate = New-SelfSignedCertificate `
                -Type Custom -Subject "CN=Sokonify Software, O=Sokonify Inc, C=TZ" `
                -KeyUsage DigitalSignature `
                -FriendlyName "Sokonify" `
                -CertStoreLocation "Cert:\CurrentUser\My" `
                -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

Write-Host $certificate
$thumbprint = $certificate.Thumbprint

$password = ConvertTo-SecureString -String "#50k0n1f4" -Force -AsPlainText
Export-PfxCertificate -cert "Cert:\CurrentUser\My\$thumbprint" -FilePath "$PSScriptRoot\$name.pfx" -Password $password