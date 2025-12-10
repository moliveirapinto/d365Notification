<#
.SYNOPSIS
    Installs required PowerShell modules for Broadcast Notification deployment

.DESCRIPTION
    Checks for and installs necessary PowerShell modules including:
    - Microsoft.Xrm.Data.PowerShell
    - Microsoft.PowerApps.PowerShell
    - AzureAD (optional)
#>

[CmdletBinding()]
param()

function Write-ColorOutput($ForegroundColor, $Message) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success($Message) { Write-ColorOutput Green "✓ $Message" }
function Write-Info($Message) { Write-ColorOutput Cyan "ℹ $Message" }

Write-Info "Checking PowerShell modules..."
Write-Host ""

# Check and install Microsoft.Xrm.Data.PowerShell
Write-Info "Checking Microsoft.Xrm.Data.PowerShell module..."
if (-not (Get-Module -ListAvailable -Name Microsoft.Xrm.Data.PowerShell)) {
    Write-Info "Installing Microsoft.Xrm.Data.PowerShell..."
    try {
        Install-Module -Name Microsoft.Xrm.Data.PowerShell -Scope CurrentUser -Force -AllowClobber
        Write-Success "Microsoft.Xrm.Data.PowerShell installed"
    } catch {
        Write-Warning "Could not install Microsoft.Xrm.Data.PowerShell: $($_.Exception.Message)"
        Write-Info "You may need to install manually or use interactive authentication"
    }
} else {
    Write-Success "Microsoft.Xrm.Data.PowerShell already installed"
}

# Check and install Microsoft.PowerApps.PowerShell
Write-Info "Checking Microsoft.PowerApps.PowerShell module..."
if (-not (Get-Module -ListAvailable -Name Microsoft.PowerApps.PowerShell.*)) {
    Write-Info "Installing Microsoft.PowerApps.PowerShell..."
    try {
        Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Scope CurrentUser -Force -AllowClobber
        Install-Module -Name Microsoft.PowerApps.PowerShell -Scope CurrentUser -Force -AllowClobber
        Write-Success "Microsoft.PowerApps.PowerShell installed"
    } catch {
        Write-Warning "Could not install Microsoft.PowerApps.PowerShell: $($_.Exception.Message)"
        Write-Info "Manual Canvas App creation will be required"
    }
} else {
    Write-Success "Microsoft.PowerApps.PowerShell already installed"
}

Write-Host ""
Write-Success "Prerequisites check completed"
Write-Host ""

exit 0
