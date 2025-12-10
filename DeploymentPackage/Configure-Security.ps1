<#
.SYNOPSIS
    Configures security roles for Broadcast Notification System

.DESCRIPTION
    Grants necessary privileges to Customer Service Supervisor role
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl
)

function Write-ColorOutput($ForegroundColor, $Message) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success($Message) { Write-ColorOutput Green "✓ $Message" }
function Write-Info($Message) { Write-ColorOutput Cyan "ℹ $Message" }
function Write-Warning2($Message) { Write-ColorOutput Yellow "⚠ $Message" }

Write-Info "Configuring security roles..."
Write-Host ""

Write-Info "Required privileges for Customer Service Supervisor role:"
Write-Host ""
Write-Host "Entity: App Notification" -ForegroundColor Cyan
Write-Host "  - Create: Organization level" -ForegroundColor White
Write-Host "  - Read: Organization level" -ForegroundColor White
Write-Host "  - Write: Organization level" -ForegroundColor White
Write-Host ""
Write-Host "Entity: System User" -ForegroundColor Cyan
Write-Host "  - Read: Organization level" -ForegroundColor White
Write-Host ""
Write-Host "Entity: Queue" -ForegroundColor Cyan
Write-Host "  - Read: Organization level" -ForegroundColor White
Write-Host ""

Write-Warning2 "Security role configuration must be done through D365 UI"
Write-Host ""
Write-Info "To configure security:"
Write-Host "1. Go to: $EnvironmentUrl" -ForegroundColor White
Write-Host "2. Settings > Security > Security Roles" -ForegroundColor White
Write-Host "3. Edit 'Customer Service Supervisor' role" -ForegroundColor White
Write-Host "4. Follow: Security/SecurityGuide.md" -ForegroundColor Cyan
Write-Host ""

$continue = Read-Host "Open security settings in browser? (Y/N)"
if ($continue -eq 'Y' -or $continue -eq 'y') {
    $securityUrl = "$EnvironmentUrl/main.aspx?settingsonly=true"
    Start-Process $securityUrl
    Write-Success "Browser opened to settings"
    Write-Host ""
    Read-Host "Press Enter after configuring security roles..."
}

Write-Host ""
Write-Success "Security configuration step completed"
exit 0
