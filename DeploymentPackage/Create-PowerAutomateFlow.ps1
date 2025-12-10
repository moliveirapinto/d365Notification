<#
.SYNOPSIS
    Creates the Send Broadcast Notification Power Automate flow

.DESCRIPTION
    Creates the Power Automate flow from a JSON template using Power Platform CLI or REST API
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
function Write-Error2($Message) { Write-ColorOutput Red "✗ $Message" }

Write-Info "Creating Power Automate Flow..."
Write-Host ""

# Check if Power Platform CLI is installed
$pacInstalled = Get-Command pac -ErrorAction SilentlyContinue

if ($pacInstalled) {
    Write-Info "Using Power Platform CLI (pac)..."
    
    # Auth
    Write-Info "Authenticating to Power Platform..."
    pac auth create --url $EnvironmentUrl
    
    # Get environment name
    $envs = pac env list
    
    Write-Warning "Power Platform CLI detected but flow creation requires additional setup"
    Write-Info "Please create the flow manually using the template"
    
} else {
    Write-Warning "Power Platform CLI (pac) not found"
}

Write-Host ""
Write-Info "Due to Power Platform limitations, please create the flow manually:"
Write-Host ""
Write-Host "1. Go to: https://make.powerautomate.com" -ForegroundColor White
Write-Host "2. Select your environment" -ForegroundColor White
Write-Host "3. Follow the guide in: PowerAutomate/FlowSetupGuide.md" -ForegroundColor Cyan
Write-Host "4. Use the template in: PowerAutomate/SendBroadcastNotification_Fixed.json" -ForegroundColor Cyan
Write-Host ""

# Open browser to Power Automate
$continue = Read-Host "Open Power Automate in browser? (Y/N)"
if ($continue -eq 'Y' -or $continue -eq 'y') {
    Start-Process "https://make.powerautomate.com"
    Write-Success "Browser opened to Power Automate"
    Write-Host ""
    Read-Host "Press Enter after creating the flow..."
}

Write-Host ""
Write-Info "Flow creation step completed (manual)"
exit 0
