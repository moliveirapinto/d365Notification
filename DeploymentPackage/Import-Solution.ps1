<#
.SYNOPSIS
    Imports Broadcast Notification System solution from ZIP file

.DESCRIPTION
    Imports a previously exported solution ZIP into a Dynamics 365 environment

.PARAMETER EnvironmentUrl
    The URL of your target Dynamics 365 environment

.PARAMETER SolutionFilePath
    Path to the solution ZIP file

.PARAMETER UpgradeExisting
    Upgrade existing solution if already installed

.EXAMPLE
    .\Import-Solution.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -SolutionFilePath ".\BroadcastNotification_1.0.0.0_Managed.zip"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$SolutionFilePath,
    
    [Parameter(Mandatory=$false)]
    [switch]$UpgradeExisting
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
function Write-Error2($Message) { Write-ColorOutput Red "✗ $Message" }

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         Broadcast Notification System - Solution Import       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check if file exists
if (-not (Test-Path $SolutionFilePath)) {
    Write-Error2 "Solution file not found: $SolutionFilePath"
    exit 1
}

Write-Success "Solution file found: $SolutionFilePath"
Write-Info "File size: $((Get-Item $SolutionFilePath).Length / 1MB) MB"
Write-Host ""

# Check prerequisites
Write-Info "Checking prerequisites..."

$pacInstalled = Get-Command pac -ErrorAction SilentlyContinue
if (-not $pacInstalled) {
    Write-Warning2 "Power Platform CLI (pac) not found"
    Write-Info "Falling back to manual import instructions..."
    Write-Host ""
    
    Write-Host "Manual Import Steps:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://make.powerapps.com" -ForegroundColor White
    Write-Host "2. Select target environment" -ForegroundColor White
    Write-Host "3. Go to: Solutions > Import solution" -ForegroundColor White
    Write-Host "4. Browse and select: $SolutionFilePath" -ForegroundColor White
    Write-Host "5. Click 'Next' > 'Import'" -ForegroundColor White
    Write-Host "6. Wait for import to complete (5-10 minutes)" -ForegroundColor White
    Write-Host ""
    
    $openBrowser = Read-Host "Open Power Apps for manual import? (Y/N)"
    if ($openBrowser -eq 'Y' -or $openBrowser -eq 'y') {
        Start-Process "https://make.powerapps.com"
    }
    
    exit 0
}

Write-Success "Power Platform CLI found"
Write-Host ""

# Connect to environment
Write-Info "Connecting to environment: $EnvironmentUrl"
Write-Host ""

try {
    pac auth create --url $EnvironmentUrl
    Write-Success "Connected to environment"
} catch {
    Write-Error2 "Failed to connect: $($_.Exception.Message)"
    exit 1
}

Write-Host ""

# Import solution
Write-Info "Importing solution..."
Write-Info "This may take 5-10 minutes..."
Write-Host ""

try {
    if ($UpgradeExisting) {
        pac solution import --path $SolutionFilePath --force-overwrite
    } else {
        pac solution import --path $SolutionFilePath
    }
    
    Write-Host ""
    Write-Success "Solution imported successfully!"
    Write-Host ""
    
    Write-Host "Post-Import Steps:" -ForegroundColor Green
    Write-Host "1. Configure connections:" -ForegroundColor White
    Write-Host "   - Open Power Apps > Solutions > BroadcastNotification" -ForegroundColor White
    Write-Host "   - Update any connection references" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Share Canvas App:" -ForegroundColor White
    Write-Host "   - Go to Apps > Broadcast Notification App" -ForegroundColor White
    Write-Host "   - Click Share and add users" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Configure security roles:" -ForegroundColor White
    Write-Host "   - See: Security/SecurityGuide.md" -ForegroundColor White
    Write-Host ""
    Write-Host "4. Test the solution:" -ForegroundColor White
    Write-Host "   - Open Customer Service Workspace" -ForegroundColor White
    Write-Host "   - Look for Broadcast Notifications menu" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Error2 "Import failed: $($_.Exception.Message)"
    Write-Host ""
    Write-Info "Try manual import instead (see instructions above)"
    exit 1
}

Write-Host ""
Write-Success "Import completed successfully!"
Write-Host ""
