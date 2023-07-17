#sensor_xdr_check_server_status
#Author : James Romeo Gaspar
#OG 1.0 01Jul2023
$trapsPath = "C:\Program Files\Palo Alto Networks\Traps"
if (-not (Test-Path $trapsPath)) {
    Write-Output "XDR not Installed : $(Get-Date)"
    exit
}

$cytoolPath = Join-Path $trapsPath "cytool.exe"
$commandOutput = & $cytoolPath websocket query
$checkinOutput = & $cytoolPath checkin
$serverResult = $commandOutput | Select-String -Pattern 'server: (.+)' | ForEach-Object { $_.Matches.Groups[1].Value }
$serverResult = $serverResult -replace '^wss://|^https://|^http://'
$serverResult = $serverResult -replace '/operations/socket$'
$connected = $commandOutput | Select-String -Pattern "connected: (.+)" | ForEach-Object { $_.Matches.Groups[1].Value }
$enabled = $commandOutput | Select-String -Pattern "enabled: (.+)" | ForEach-Object { $_.Matches.Groups[1].Value }
if ($connected -eq "true" -and $enabled -eq "true") {
    Write-Output "Server: $serverResult | Connection: True : $(Get-Date)"
} else {
    Write-Output "Server: $serverResult | Connection: Warning : $(Get-Date)"
}
