# ================================================
# Active Directory User Check Tool
# Author: Oluseye Owoeye
# Date: July 2026
# Purpose: Level 1/2 IT Support - AD User Diagnostics
# GitHub: github.com/Oluseyecode/it-lab-scripts
# ================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "        ACTIVE DIRECTORY USER CHECK TOOL       " -ForegroundColor Cyan
Write-Host "        Level 1/2 IT Support Toolkit           " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# ── CHECK IF AD MODULE IS AVAILABLE ──
$adAvailable = Get-Module -ListAvailable -Name ActiveDirectory

if (-not $adAvailable) {
    Write-Host "Active Directory module not found on this machine." -ForegroundColor Yellow
    Write-Host "Switching to LOCAL USER simulation mode..." -ForegroundColor Yellow
    Write-Host ""

    # ── LOCAL USER SIMULATION MODE ──
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "         LOCAL USER ACCOUNT CHECK              " -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""

    # Get all local users
    $localUsers = Get-LocalUser

    Write-Host "[ ALL LOCAL USER ACCOUNTS ]" -ForegroundColor Yellow
    Write-Host "------------------------------------------------" -ForegroundColor DarkGray

    foreach ($user in $localUsers) {
        Write-Host ""
        Write-Host "Username:     " -NoNewline
        Write-Host $user.Name -ForegroundColor Green

        Write-Host "Enabled:      " -NoNewline
        if ($user.Enabled) {
            Write-Host "YES - Account is active" -ForegroundColor Green
        } else {
            Write-Host "NO - Account is disabled" -ForegroundColor Red
        }

        Write-Host "Last Logon:   " -NoNewline
        if ($user.LastLogon) {
            Write-Host $user.LastLogon -ForegroundColor Green
        } else {
            Write-Host "Never logged in" -ForegroundColor Yellow
        }

        Write-Host "Password Set: " -NoNewline
        if ($user.PasswordLastSet) {
            Write-Host $user.PasswordLastSet -ForegroundColor Green
        } else {
            Write-Host "Never set" -ForegroundColor Yellow
        }

        Write-Host "Description:  " -NoNewline
        if ($user.Description) {
            Write-Host $user.Description -ForegroundColor Green
        } else {
            Write-Host "No description" -ForegroundColor DarkGray
        }

        Write-Host "------------------------------------------------" -ForegroundColor DarkGray
    }

    # ── ACCOUNT HEALTH SUMMARY ──
    Write-Host ""
    Write-Host "[ ACCOUNT HEALTH SUMMARY ]" -ForegroundColor Yellow
    Write-Host "------------------------------------------------" -ForegroundColor DarkGray

    $totalUsers = $localUsers.Count
    $enabledUsers = ($localUsers | Where-Object { $_.Enabled -eq $true }).Count
    $disabledUsers = ($localUsers | Where-Object { $_.Enabled -eq $false }).Count
    $neverLoggedIn = ($localUsers | Where-Object { $_.LastLogon -eq $null }).Count

    Write-Host "Total Accounts:      " -NoNewline
    Write-Host $totalUsers -ForegroundColor Green

    Write-Host "Active Accounts:     " -NoNewline
    Write-Host $enabledUsers -ForegroundColor Green

    Write-Host "Disabled Accounts:   " -NoNewline
    if ($disabledUsers -gt 0) {
        Write-Host $disabledUsers -ForegroundColor Yellow
    } else {
        Write-Host $disabledUsers -ForegroundColor Green
    }

    Write-Host "Never Logged In:     " -NoNewline
    if ($neverLoggedIn -gt 0) {
        Write-Host $neverLoggedIn -ForegroundColor Yellow
    } else {
        Write-Host $neverLoggedIn -ForegroundColor Green
    }

    # ── COMMON AD TICKET SIMULATIONS ──
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "     COMMON LEVEL 1/2 AD TICKET RESPONSES      " -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "TICKET: User cannot log in" -ForegroundColor Yellow
    Write-Host "RESPONSE: Check if account is enabled. If disabled - enable it." -ForegroundColor White
    Write-Host "COMMAND:  Enable-LocalUser -Name 'username'" -ForegroundColor Green
    Write-Host ""

    Write-Host "TICKET: User forgot password" -ForegroundColor Yellow
    Write-Host "RESPONSE: Reset password and force change at next login." -ForegroundColor White
    Write-Host "COMMAND:  Set-LocalUser -Name 'username' -Password (Read-Host -AsSecureString)" -ForegroundColor Green
    Write-Host ""

    Write-Host "TICKET: Account locked out" -ForegroundColor Yellow
    Write-Host "RESPONSE: In AD - find user, right click, unlock account." -ForegroundColor White
    Write-Host "AD CMD:   Unlock-ADAccount -Identity 'username'" -ForegroundColor Green
    Write-Host ""

    Write-Host "TICKET: New employee needs account" -ForegroundColor Yellow
    Write-Host "RESPONSE: Create account, add to correct group, set temp password." -ForegroundColor White
    Write-Host "AD CMD:   New-ADUser -Name 'Full Name' -SamAccountName 'username' -Enabled `$true" -ForegroundColor Green
    Write-Host ""

} else {

    # ── FULL AD MODE (when connected to domain) ──
    Write-Host "Active Directory module detected." -ForegroundColor Green
    Write-Host "Enter a username to check their AD account:" -ForegroundColor Cyan
    Write-Host ""

    $username = Read-Host "Username"

    try {
        $user = Get-ADUser -Identity $username -Properties * -ErrorAction Stop

        Write-Host ""
        Write-Host "[ AD ACCOUNT DETAILS: $username ]" -ForegroundColor Yellow
        Write-Host "------------------------------------------------" -ForegroundColor DarkGray

        Write-Host "Full Name:      " -NoNewline
        Write-Host $user.DisplayName -ForegroundColor Green

        Write-Host "Email:          " -NoNewline
        Write-Host $user.EmailAddress -ForegroundColor Green

        Write-Host "Department:     " -NoNewline
        Write-Host $user.Department -ForegroundColor Green

        Write-Host "Account Enabled:" -NoNewline
        if ($user.Enabled) {
            Write-Host " YES" -ForegroundColor Green
        } else {
            Write-Host " NO - ACCOUNT DISABLED" -ForegroundColor Red
        }

        Write-Host "Locked Out:     " -NoNewline
        if ($user.LockedOut) {
            Write-Host "YES - ACCOUNT LOCKED" -ForegroundColor Red
            Write-Host "FIX: Run Unlock-ADAccount -Identity '$username'" -ForegroundColor Yellow
        } else {
            Write-Host "NO" -ForegroundColor Green
        }

        Write-Host "Password Expired:" -NoNewline
        if ($user.PasswordExpired) {
            Write-Host " YES - PASSWORD EXPIRED" -ForegroundColor Red
            Write-Host "FIX: Reset password in AD Users and Computers" -ForegroundColor Yellow
        } else {
            Write-Host " NO" -ForegroundColor Green
        }

        Write-Host "Last Logon:     " -NoNewline
        Write-Host $user.LastLogonDate -ForegroundColor Green

        Write-Host "Password Last Set:" -NoNewline
        Write-Host $user.PasswordLastSet -ForegroundColor Green

        Write-Host "Member Of:" -ForegroundColor Yellow
        $user.MemberOf | ForEach-Object {
            Write-Host "  - $_" -ForegroundColor Green
        }

    } catch {
        Write-Host ""
        Write-Host "User '$username' not found in Active Directory." -ForegroundColor Red
        Write-Host "Check spelling or search with: Get-ADUser -Filter {Name -like '*$username*'}" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  END OF AD CHECK - $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""