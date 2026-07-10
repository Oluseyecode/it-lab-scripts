# ================================================
# Network Diagnostics Tool
# Author: Oluseye Owoeye
# Date: July 2026
# Purpose: Level 1/2 IT Support - Network Troubleshooting
# GitHub: github.com/Oluseyecode/it-lab-scripts
# ================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "         NETWORK DIAGNOSTICS TOOL              " -ForegroundColor Cyan
Write-Host "         Level 1/2 IT Support Toolkit          " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# ── STEP 1: IP CONFIGURATION ──
Write-Host "[ STEP 1 ] Checking IP Configuration..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

$network = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }

if ($network) {
    $ip = $network.IPv4Address.IPAddress
    $gateway = $network.IPv4DefaultGateway.NextHop
    $dns = $network.DNSServer.ServerAddresses | Select-Object -First 1

    Write-Host "IP Address:      " -NoNewline
    Write-Host $ip -ForegroundColor Green

    Write-Host "Default Gateway: " -NoNewline
    Write-Host $gateway -ForegroundColor Green

    Write-Host "DNS Server:      " -NoNewline
    Write-Host $dns -ForegroundColor Green

    # Check for APIPA address (169.254.x.x = DHCP failure)
    if ($ip -like "169.254.*") {
        Write-Host ""
        Write-Host "WARNING: APIPA address detected (169.254.x.x)" -ForegroundColor Red
        Write-Host "DIAGNOSIS: DHCP server unreachable - device has no valid IP" -ForegroundColor Red
        Write-Host "FIX: Run ipconfig /release then ipconfig /renew" -ForegroundColor Yellow
    }
} else {
    Write-Host "No active network connection found" -ForegroundColor Red
}

Write-Host ""

# ── STEP 2: PING DEFAULT GATEWAY ──
Write-Host "[ STEP 2 ] Pinging Default Gateway..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

$pingGateway = Test-Connection -ComputerName $gateway -Count 2 -Quiet -ErrorAction SilentlyContinue

if ($pingGateway) {
    Write-Host "Gateway ($gateway): " -NoNewline
    Write-Host "REACHABLE" -ForegroundColor Green
} else {
    Write-Host "Gateway ($gateway): " -NoNewline
    Write-Host "UNREACHABLE" -ForegroundColor Red
    Write-Host "DIAGNOSIS: Cannot reach router - check cable or WiFi connection" -ForegroundColor Yellow
}

Write-Host ""

# ── STEP 3: PING GOOGLE DNS (INTERNET TEST) ──
Write-Host "[ STEP 3 ] Testing Internet Connectivity (8.8.8.8)..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

$pingInternet = Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet -ErrorAction SilentlyContinue

if ($pingInternet) {
    Write-Host "Internet (8.8.8.8): " -NoNewline
    Write-Host "CONNECTED" -ForegroundColor Green
} else {
    Write-Host "Internet (8.8.8.8): " -NoNewline
    Write-Host "UNREACHABLE" -ForegroundColor Red
    Write-Host "DIAGNOSIS: Gateway reachable but no internet - check router or ISP" -ForegroundColor Yellow
}

Write-Host ""

# ── STEP 4: DNS RESOLUTION TEST ──
Write-Host "[ STEP 4 ] Testing DNS Resolution..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

try {
    $dnsTest = Resolve-DnsName -Name "google.com" -ErrorAction Stop
    Write-Host "DNS Resolution (google.com): " -NoNewline
    Write-Host "SUCCESS" -ForegroundColor Green
    Write-Host "Resolved to: " -NoNewline
    Write-Host ($dnsTest | Select-Object -First 1).IPAddress -ForegroundColor Green
} catch {
    Write-Host "DNS Resolution: " -NoNewline
    Write-Host "FAILED" -ForegroundColor Red
    Write-Host "DIAGNOSIS: DNS server not responding" -ForegroundColor Yellow
    Write-Host "FIX: Run ipconfig /flushdns or change DNS to 8.8.8.8 manually" -ForegroundColor Yellow
}

Write-Host ""

# ── STEP 5: ACTIVE NETWORK ADAPTERS ──
Write-Host "[ STEP 5 ] Checking Active Network Adapters..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

if ($adapters) {
    foreach ($adapter in $adapters) {
        Write-Host "Adapter: " -NoNewline
        Write-Host $adapter.Name -ForegroundColor Green -NoNewline
        Write-Host "  |  Status: " -NoNewline
        Write-Host $adapter.Status -ForegroundColor Green -NoNewline
        Write-Host "  |  Speed: " -NoNewline
        Write-Host "$([math]::Round($adapter.LinkSpeed/1000000))Mbps" -ForegroundColor Green
    }
} else {
    Write-Host "No active network adapters found" -ForegroundColor Red
}

Write-Host ""

# ── SUMMARY ──
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "              DIAGNOSTIC SUMMARY               " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

Write-Host "IP Config:    " -NoNewline
if ($ip -and $ip -notlike "169.254.*") { Write-Host "OK" -ForegroundColor Green } else { Write-Host "ISSUE DETECTED" -ForegroundColor Red }

Write-Host "Gateway:      " -NoNewline
if ($pingGateway) { Write-Host "OK" -ForegroundColor Green } else { Write-Host "UNREACHABLE" -ForegroundColor Red }

Write-Host "Internet:     " -NoNewline
if ($pingInternet) { Write-Host "OK" -ForegroundColor Green } else { Write-Host "UNREACHABLE" -ForegroundColor Red }

Write-Host "DNS:          " -NoNewline
try {
    Resolve-DnsName -Name "google.com" -ErrorAction Stop | Out-Null
    Write-Host "OK" -ForegroundColor Green
} catch {
    Write-Host "FAILED" -ForegroundColor Red
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  END OF NETWORK DIAGNOSTICS - $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""