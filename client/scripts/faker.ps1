Write-Host "Start faker"
Set-Location $PSScriptRoot

cd..
cd..

cd server/graph

graphql-faker -o schema.graphqls