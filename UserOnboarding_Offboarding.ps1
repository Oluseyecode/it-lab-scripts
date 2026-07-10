# ================================================
# New Employee Onboarding Automation Tool
# Author: Oluseye Owoeye
# Date: July 2026
# Purpose: Level 2 IT Support - User Onboarding
# GitHub: github.com/Oluseyecode/it-lab-scripts
# ================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "     NEW EMPLOYEE ONBOARDING AUTOMATION        " -ForegroundColor Cyan
Write-Host "     Level 2 IT Support Toolkit                " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# ── COLLECT NEW EMPLOYEE DETAILS ──
Write-Host "[ STEP 1 ] Enter New Employee Details" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

$firstName   = Read-Host "First Name"
$lastName    = Read-Host "Last Name"
$department  = Read-Host "Department (IT / Finance / HR / Sales)"
$jobTitle    = Read-Host "Job Title"
$manager     = Read-Host "Manager Name"
$startDate   = Read-Host "Start Date (dd/MM/yyyy)"

$fullName    = "$firstName $lastName"
$username    = ($firstName.Substring(0,1) + $lastName).ToLower()
$email       = "$username@company.com"
$tempPass    = "Welcome@" + (Get-Date -Format "yyyy") + "!"

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "         ONBOARDING CHECKLIST REPORT           " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# ── ACCOUNT DETAILS ──
Write-Host "[ ACCOUNT DETAILS ]" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
Write-Host "Full Name:        " -NoNewline
Write-Host $fullName -ForegroundColor Green
Write-Host "Username:         " -NoNewline
Write-Host $username -ForegroundColor Green
Write-Host "Email:            " -NoNewline
Write-Host $email -ForegroundColor Green
Write-Host "Temp Password:    " -NoNewline
Write-Host $tempPass -ForegroundColor Yellow
Write-Host "Department:       " -NoNewline
Write-Host $department -ForegroundColor Green
Write-Host "Job Title:        " -NoNewline
Write-Host $jobTitle -ForegroundColor Green
Write-Host "Manager:          " -NoNewline
Write-Host $manager -ForegroundColor Green
Write-Host "Start Date:       " -NoNewline
Write-Host $startDate -ForegroundColor Green
Write-Host ""

# ── ONBOARDING TASKS ──
Write-Host "[ ONBOARDING TASKS - LEVEL 2 IT CHECKLIST ]" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

$tasks = @(
    "Create Active Directory account for $fullName",
    "Set username: $username and temp password: $tempPass",
    "Add $username to $department security group in AD",
    "Create Microsoft 365 account: $email",
    "Assign Microsoft 365 licence to $email",
    "Configure Outlook profile and test email send/receive",
    "Enrol device in Microsoft Intune MDM",
    "Apply $department compliance policy via Intune",
    "Install required software for $department department",
    "Configure VPN access for $fullName",
    "Add $username to relevant shared drives and folders",
    "Set up MFA (Multi-Factor Authentication) for $email",
    "Create Jira Service Management account for $username",
    "Send welcome email to $email with login credentials",
    "Schedule IT orientation session for $startDate",
    "Document onboarding completion in Confluence"
)

$taskNumber = 1
foreach ($task in $tasks) {
    Write-Host "  [ ] $taskNumber. $task" -ForegroundColor White
    $taskNumber++
}

Write-Host ""

# ── AD COMMANDS TO RUN ──
Write-Host "[ POWERSHELL COMMANDS TO EXECUTE IN AD ]" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "# Create AD User:" -ForegroundColor DarkGray
Write-Host "New-ADUser -Name '$fullName' ``" -ForegroundColor Green
Write-Host "           -GivenName '$firstName' ``" -ForegroundColor Green
Write-Host "           -Surname '$lastName' ``" -ForegroundColor Green
Write-Host "           -SamAccountName '$username' ``" -ForegroundColor Green
Write-Host "           -UserPrincipalName '$email' ``" -ForegroundColor Green
Write-Host "           -Department '$department' ``" -ForegroundColor Green
Write-Host "           -Title '$jobTitle' ``" -ForegroundColor Green
Write-Host "           -Enabled `$true" -ForegroundColor Green
Write-Host ""
Write-Host "# Add to Department Group:" -ForegroundColor DarkGray
Write-Host "Add-ADGroupMember -Identity '$department-Team' -Members '$username'" -ForegroundColor Green
Write-Host ""
Write-Host "# Force Password Change at First Login:" -ForegroundColor DarkGray
Write-Host "Set-ADUser -Identity '$username' -ChangePasswordAtLogon `$true" -ForegroundColor Green
Write-Host ""

# ── OFFBOARDING REFERENCE ──
Write-Host "[ OFFBOARDING COMMANDS - FOR REFERENCE ]" -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "# Disable account when employee leaves:" -ForegroundColor DarkGray
Write-Host "Disable-ADAccount -Identity '$username'" -ForegroundColor Red
Write-Host ""
Write-Host "# Remove from all groups:" -ForegroundColor DarkGray
Write-Host "Get-ADUser '$username' -Properties MemberOf | Select -Expand MemberOf | ``" -ForegroundColor Red
Write-Host "ForEach-Object { Remove-ADGroupMember -Identity `$_ -Members '$username' -Confirm:`$false }" -ForegroundColor Red
Write-Host ""
Write-Host "# Revoke Microsoft 365 sessions:" -ForegroundColor DarkGray
Write-Host "Revoke-AzureADUserAllRefreshToken -ObjectId '$email'" -ForegroundColor Red
Write-Host ""

# ── SAVE REPORT ──
$reportPath = "C:\IT-Lab\Documentation\Onboarding_$username`_$(Get-Date -Format 'yyyyMMdd').txt"

$report = @"
================================================
NEW EMPLOYEE ONBOARDING REPORT
Generated: $(Get-Date -Format 'dd/MM/yyyy HH:mm')
================================================
Full Name:    $fullName
Username:     $username
Email:        $email
Department:   $department
Job Title:    $jobTitle
Manager:      $manager
Start Date:   $startDate
Temp Password: $tempPass
================================================
STATUS: Onboarding initiated - checklist pending completion
================================================
"@

$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  ONBOARDING REPORT SAVED TO:" -ForegroundColor Cyan
Write-Host "  $reportPath" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Onboarding initiated for $fullName on $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor Green
Write-Host ""