# ================================================
# IT Asset Inventory Tool
# Author: Oluseye Owoeye
# Date: July 2026
# Purpose: Level 1/2 IT Support - Asset Management
# GitHub: github.com/Oluseyecode/it-lab-scripts
# ================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "          IT ASSET INVENTORY TOOL              " -ForegroundColor Cyan
Write-Host "          Level 1/2 IT Support Toolkit         " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# SECTION 1: COMPUTER INFORMATION
Write-Host "[ SECTION 1 ] Computer Information" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

$computer  = Get-CimInstance Win32_ComputerSystem
$os        = Get-CimInstance Win32_OperatingSystem
$bios      = Get-CimInstance Win32_BIOS
$cpu       = Get-CimInstance Win32_Processor

Write-Host "Computer Name:    " -NoNewline
Write-Host $env:COMPUTERNAME -ForegroundColor Green
Write-Host "Manufacturer:     " -NoNewline
Write-Host $computer.Manufacturer -ForegroundColor Green
Write-Host "Model:            " -NoNewline
Write-Host $computer.Model -ForegroundColor Green
Write-Host "Serial Number:    " -NoNewline
Write-Host $bios.SerialNumber -ForegroundColor Green
Write-Host "Operating System: " -NoNewline
Write-Host $os.Caption -ForegroundColor Green
Write-Host "OS Version:       " -NoNewline
Write-Host $os.Version -ForegroundColor Green
Write-Host "Last Boot Time:   " -NoNewline
Write-Host $os.LastBootUpTime -ForegroundColor Green
Write-Host ""

# SECTION 2: CPU
Write-Host "[ SECTION 2 ] Processor" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
Write-Host "Processor:        " -NoNewline
Write-Host $cpu.Name -ForegroundColor Green
Write-Host "Cores:            " -NoNewline
Write-Host $cpu.NumberOfCores -ForegroundColor Green
Write-Host "Logical CPUs:     " -NoNewline
Write-Host $cpu.NumberOfLogicalProcessors -ForegroundColor Green
Write-Host ""

# SECTION 3: RAM
Write-Host "[ SECTION 3 ] Memory" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
$totalRAM   = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeRAM    = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedRAM    = [math]::Round($totalRAM - $freeRAM, 2)
$ramPct     = [math]::Round(($usedRAM / $totalRAM) * 100, 0)
Write-Host "Total RAM:        $totalRAM GB" -ForegroundColor Green
Write-Host "Used RAM:         $usedRAM GB ($ramPct%)" -ForegroundColor Yellow
Write-Host "Free RAM:         $freeRAM GB" -ForegroundColor Green
Write-Host ""

# SECTION 4: DISK
Write-Host "[ SECTION 4 ] Disk Drives" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
$disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
foreach ($disk in $disks) {
    $tot  = [math]::Round($disk.Size / 1GB, 2)
    $free = [math]::Round($disk.FreeSpace / 1GB, 2)
    $used = [math]::Round($tot - $free, 2)
    $pct  = [math]::Round(($free / $tot) * 100, 0)
    if ($pct -lt 10) {
        Write-Host "Drive $($disk.DeviceID) Total:$tot GB Used:$used GB Free:$free GB ($pct% free) CRITICAL" -ForegroundColor Red
    } elseif ($pct -lt 20) {
        Write-Host "Drive $($disk.DeviceID) Total:$tot GB Used:$used GB Free:$free GB ($pct% free) WARNING" -ForegroundColor Yellow
    } else {
        Write-Host "Drive $($disk.DeviceID) Total:$tot GB Used:$used GB Free:$free GB ($pct% free)" -ForegroundColor Green
    }
}
Write-Host ""# SECTION 5: NETWORK
Write-Host "[ SECTION 5 ] Network Adapters" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($adapter in $adapters) {
    $ip = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
    Write-Host "Adapter:    $($adapter.Name)" -ForegroundColor Green
    Write-Host "MAC:        $($adapter.MacAddress)" -ForegroundColor Green
    Write-Host "Speed:      $([math]::Round($adapter.LinkSpeed/1000000)) Mbps" -ForegroundColor Green
    if ($ip) { Write-Host "IP:         $($ip.IPAddress)" -ForegroundColor Green }
    Write-Host ""
}

# SECTION 6: INSTALLED SOFTWARE
Write-Host "[ SECTION 6 ] Installed Software (Top 20)" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
$software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object { $_.DisplayName -ne $null } |
    Select-Object DisplayName, DisplayVersion |
    Sort-Object DisplayName |
    Select-Object -First 20
foreach ($app in $software) {
    Write-Host "  $($app.DisplayName) v$($app.DisplayVersion)" -ForegroundColor Green
}
Write-Host ""

# SECTION 7: LOCAL USERS
Write-Host "[ SECTION 7 ] Local User Accounts" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
$users = Get-LocalUser
foreach ($user in $users) {
    $status = if ($user.Enabled) { "ACTIVE" } else { "DISABLED" }
    $color  = if ($user.Enabled) { "Green" } else { "Red" }
    Write-Host "  $($user.Name) - $status" -ForegroundColor $color
}
Write-Host ""

# EXPORT TO CSV
Write-Host "[ EXPORTING ASSET REPORT ]" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray

$reportPath = "C:\IT-Lab\Documentation\AssetInventory_$env:COMPUTERNAME`_$(Get-Date -Format 'yyyyMMdd_HHmm').csv"

$assetData = [PSCustomObject]@{
    ComputerName    = $env:COMPUTERNAME
    Manufacturer    = $computer.Manufacturer
    Model           = $computer.Model
    SerialNumber    = $bios.SerialNumber
    OS              = $os.Caption
    OSVersion       = $os.Version
    Processor       = $cpu.Name
    Cores           = $cpu.NumberOfCores
    TotalRAM_GB     = $totalRAM
    FreeRAM_GB      = $freeRAM
    ReportDate      = (Get-Date -Format 'dd/MM/yyyy HH:mm')
}

$assetData | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8

Write-Host "Report saved to: $reportPath" -ForegroundColor Green
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  ASSET INVENTORY COMPLETE - $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""