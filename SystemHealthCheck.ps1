# System Health Check Script
# Created by: Your Name
# Date: July 2026
# Purpose: Quick system health overview for IT support

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       SYSTEM HEALTH CHECK REPORT       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Computer Name and OS
$computerInfo = Get-ComputerInfo | Select-Object CsName, OsName, OsVersion
Write-Host "`nComputer Name: " -NoNewline
Write-Host $computerInfo.CsName -ForegroundColor Green

Write-Host "Operating System: " -NoNewline
Write-Host $computerInfo.OsName -ForegroundColor Green

# RAM Check
$ram = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($ram.TotalVisibleMemorySize / 1MB, 2)
$freeRAM = [math]::Round($ram.FreePhysicalMemory / 1MB, 2)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 2)

Write-Host "`nRAM Total: " -NoNewline
Write-Host "$totalRAM GB" -ForegroundColor Green
Write-Host "RAM Used:  " -NoNewline
Write-Host "$usedRAM GB" -ForegroundColor Yellow
Write-Host "RAM Free:  " -NoNewline
Write-Host "$freeRAM GB" -ForegroundColor Green

# Disk Space Check
$disk = Get-PSDrive C
$totalDisk = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)
$freeDisk = [math]::Round($disk.Free / 1GB, 2)
$usedDisk = [math]::Round($disk.Used / 1GB, 2)

Write-Host "`nDisk Total: " -NoNewline
Write-Host "$totalDisk GB" -ForegroundColor Green
Write-Host "Disk Used:  " -NoNewline
Write-Host "$usedDisk GB" -ForegroundColor Yellow
Write-Host "Disk Free:  " -NoNewline
Write-Host "$freeDisk GB" -ForegroundColor Green

# Network Check
Write-Host "`nNetwork Status:" -ForegroundColor Cyan
$network = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null}
Write-Host "IP Address:      " -NoNewline
Write-Host $network.IPv4Address.IPAddress -ForegroundColor Green
Write-Host "Default Gateway: " -NoNewline
Write-Host $network.IPv4DefaultGateway.NextHop -ForegroundColor Green

# Internet Connectivity Check
Write-Host "`nInternet Connectivity:" -ForegroundColor Cyan
$ping = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet
if ($ping) {
    Write-Host "Internet: CONNECTED" -ForegroundColor Green
} else {
    Write-Host "Internet: DISCONNECTED" -ForegroundColor Red
}

# Running Services Count
$services = (Get-Service | Where-Object {$_.Status -eq "Running"}).Count
Write-Host "`nRunning Services: " -NoNewline
Write-Host $services -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "         END OF HEALTH CHECK            " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan