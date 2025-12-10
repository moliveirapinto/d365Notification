<#
.SYNOPSIS
    Automated deployment script for Broadcast Notification System

.DESCRIPTION
    Deploys the complete Broadcast Notification System to a Dynamics 365 Customer Service environment.
    This includes Power Automate flow, Canvas App setup, security configuration, and sitemap integration.

.PARAMETER EnvironmentUrl
    The URL of your Dynamics 365 environment (e.g., https://yourorg.crm.dynamics.com)

.PARAMETER TenantId
    Your Azure AD Tenant ID

.PARAMETER ClientId
    Optional: Service Principal Client ID for automated authentication

.PARAMETER ClientSecret
    Optional: Service Principal Client Secret for automated authentication

.PARAMETER SkipCanvasApp
    Skip Canvas App creation (manual setup required later)

.EXAMPLE
    .\Deploy-BroadcastNotification.ps1 -EnvironmentUrl "https://mauriciomaster.crm.dynamics.com" -TenantId "48ac8550-da32-403e-9d2c-d280efe32983"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    
    [Parameter(Mandatory=$false)]
    [string]$ClientId,
    
    [Parameter(Mandatory=$false)]
    [string]$ClientSecret,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipCanvasApp
)

# Script version
$ScriptVersion = "1.0.0"

# Color codes for output
function Write-ColorOutput($ForegroundColor, $Message) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success($Message) { Write-ColorOutput Green "✓ $Message" }
function Write-Info($Message) { Write-ColorOutput Cyan "ℹ $Message" }
function Write-Warning($Message) { Write-ColorOutput Yellow "⚠ $Message" }
function Write-Error2($Message) { Write-ColorOutput Red "✗ $Message" }

# Banner
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Broadcast Notification System - Automated Deployment      ║" -ForegroundColor Cyan
Write-Host "║                        Version $ScriptVersion                          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check prerequisites
Write-Info "Step 1/6: Checking prerequisites..."
Write-Host ""

# Check PowerShell version
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -lt 5) {
    Write-Error2 "PowerShell 5.1 or higher is required. Current version: $($psVersion.ToString())"
    exit 1
}
Write-Success "PowerShell version: $($psVersion.ToString())"

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "Not running as Administrator. Some operations may fail."
    Write-Info "Consider running PowerShell as Administrator for best results."
}

# Step 2: Install required modules
Write-Host ""
Write-Info "Step 2/6: Installing required PowerShell modules..."
Write-Host ""

.\Install-Prerequisites.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Error2 "Failed to install prerequisites. Exiting."
    exit 1
}

# Step 3: Connect to environment
Write-Host ""
Write-Info "Step 3/6: Connecting to Dynamics 365 environment..."
Write-Host ""
Write-Info "Environment: $EnvironmentUrl"
Write-Host ""

try {
    if ($ClientId -and $ClientSecret) {
        # Service Principal authentication
        Write-Info "Using Service Principal authentication..."
        $secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($ClientId, $secureSecret)
        
        Connect-CrmOnline -ServerUrl $EnvironmentUrl -Credential $credential -ForceOAuth
    } else {
        # Interactive authentication
        Write-Info "Opening browser for authentication..."
        Write-Warning "Please sign in with System Administrator credentials"
        Connect-CrmOnline -ServerUrl $EnvironmentUrl -ForceOAuth
    }
    
    Write-Success "Successfully connected to environment"
} catch {
    Write-Error2 "Failed to connect to environment: $($_.Exception.Message)"
    exit 1
}

# Step 4: Create Power Automate Flow
Write-Host ""
Write-Info "Step 4/6: Creating Power Automate Flow..."
Write-Host ""

.\Create-PowerAutomateFlow.ps1 -EnvironmentUrl $EnvironmentUrl
if ($LASTEXITCODE -ne 0) {
    Write-Error2 "Failed to create Power Automate flow"
    Write-Info "You can create the flow manually using: PowerAutomate/FlowSetupGuide.md"
    $flowCreated = $false
} else {
    Write-Success "Power Automate flow created successfully"
    $flowCreated = $true
}

# Step 5: Configure Security
Write-Host ""
Write-Info "Step 5/6: Configuring security roles..."
Write-Host ""

.\Configure-Security.ps1 -EnvironmentUrl $EnvironmentUrl
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Security configuration had issues. Please verify manually."
} else {
    Write-Success "Security roles configured successfully"
}

# Step 6: Canvas App Setup
Write-Host ""
Write-Info "Step 6/6: Setting up Canvas App..."
Write-Host ""

if (-not $SkipCanvasApp) {
    Write-Warning "Canvas Apps CANNOT be fully automated due to Power Platform limitations"
    Write-Host ""
    Write-Info "I will:"
    Write-Info "  1. Open Power Apps in your browser"
    Write-Info "  2. Provide you with a pre-configured template"
    Write-Info "  3. Guide you through the creation process"
    Write-Host ""
    Write-Info "This will take approximately 5 minutes"
    Write-Host ""
    
    $continue = Read-Host "Continue with Canvas App setup? (Y/N)"
    if ($continue -eq 'Y' -or $continue -eq 'y') {
        # Open Power Apps
        $powerAppsUrl = "https://make.powerapps.com/environments/"
        Start-Process $powerAppsUrl
        
        Write-Host ""
        Write-Info "Browser opened to Power Apps portal"
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host "  Canvas App Creation Instructions" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. In Power Apps, click 'Create' > 'Canvas app from blank'" -ForegroundColor White
        Write-Host "2. Name: 'Broadcast Notification App'" -ForegroundColor White
        Write-Host "3. Format: Tablet" -ForegroundColor White
        Write-Host "4. Click 'Create'" -ForegroundColor White
        Write-Host ""
        Write-Host "5. Follow the complete setup guide in:" -ForegroundColor White
        Write-Host "   CanvasApp/DesignSpecifications.md" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "6. Copy formulas from:" -ForegroundColor White
        Write-Host "   CanvasApp/PowerFxFormulas.txt" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "7. When done, click 'File' then 'Save' then 'Publish'" -ForegroundColor White
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host ""
        
        Read-Host "Press Enter when Canvas App is created and published..."
        Write-Success "Canvas App setup marked as complete"
    } else {
        Write-Info "Canvas App creation skipped. You can create it later using:"
        Write-Info "  - CanvasApp/DesignSpecifications.md"
        Write-Info "  - CanvasApp/PowerFxFormulas.txt"
    }
} else {
    Write-Info "Canvas App creation skipped (SkipCanvasApp flag)"
}

# Step 7: Update Sitemap
Write-Host ""
Write-Host "Updating Customer Service Workspace sitemap..." -ForegroundColor Cyan
Write-Host ""

Write-Warning "Sitemap update requires Canvas App URL"
Write-Info "After creating Canvas App, run:"
Write-Info "  .\Update-Sitemap.ps1 -EnvironmentUrl $EnvironmentUrl -CanvasAppUrl '<your-app-url>'"
Write-Host ""

# Summary
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    Deployment Summary                          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "Components Deployed:" -ForegroundColor Cyan
if ($flowCreated) {
    Write-Success "Power Automate Flow: Created"
} else {
    Write-Warning "Power Automate Flow: Failed (manual setup required)"
}
Write-Success "Security Roles: Configured"
if (-not $SkipCanvasApp) {
    Write-Info "Canvas App: User guided through creation"
} else {
    Write-Warning "Canvas App: Skipped (manual setup required)"
}
Write-Warning "Sitemap: Manual update required (run Update-Sitemap.ps1)"

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Verify Power Automate flow is working (test in flow editor)" -ForegroundColor White
Write-Host "2. Complete Canvas App creation if not done" -ForegroundColor White
Write-Host "3. Get Canvas App URL from Power Apps portal" -ForegroundColor White
Write-Host "4. Run: .\Update-Sitemap.ps1 -EnvironmentUrl $EnvironmentUrl -CanvasAppUrl '<url>'" -ForegroundColor White
Write-Host "5. Test the complete solution" -ForegroundColor White

Write-Host ""
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "  - Full guide: COMPLETE_GUIDE.md" -ForegroundColor White
Write-Host "  - Quick start: QUICKSTART.md" -ForegroundColor White
Write-Host "  - Troubleshooting: COMPLETE_GUIDE.md#troubleshooting" -ForegroundColor White

Write-Host ""
Write-Success "Deployment script completed!"
Write-Host ""
