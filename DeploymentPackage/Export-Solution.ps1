<#
.SYNOPSIS
    Exports Broadcast Notification System as a solution ZIP file

.DESCRIPTION
    Creates a solution in the environment, adds all components, and exports it as a ZIP file
    for distribution to other environments.

.PARAMETER EnvironmentUrl
    The URL of your Dynamics 365 environment

.PARAMETER SolutionName
    Name of the solution (default: BroadcastNotification)

.PARAMETER Version
    Solution version (default: 1.0.0.0)

.PARAMETER ExportPath
    Path where the solution ZIP will be saved (default: current directory)

.PARAMETER Managed
    Export as managed solution (recommended for distribution)

.EXAMPLE
    .\Export-Solution.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -Managed
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$SolutionName = "BroadcastNotification",
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "1.0.0.0",
    
    [Parameter(Mandatory=$false)]
    [string]$ExportPath = ".",
    
    [Parameter(Mandatory=$false)]
    [switch]$Managed
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
Write-Host "║         Broadcast Notification System - Solution Export       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Info "Checking prerequisites..."

$pacInstalled = Get-Command pac -ErrorAction SilentlyContinue
if (-not $pacInstalled) {
    Write-Warning2 "Power Platform CLI (pac) not found"
    Write-Info "Please install from: https://aka.ms/PowerPlatformCLI"
    Write-Host ""
    Write-Info "After installation, run this script again"
    exit 1
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

# Check if solution exists
Write-Info "Checking if solution exists..."
$solutionExists = $false

try {
    $solutions = pac solution list
    if ($solutions -match $SolutionName) {
        $solutionExists = $true
        Write-Success "Solution '$SolutionName' found"
    } else {
        Write-Warning2 "Solution '$SolutionName' not found"
    }
} catch {
    Write-Warning2 "Could not query solutions"
}

Write-Host ""

# If solution doesn't exist, provide guidance
if (-not $solutionExists) {
    Write-Warning2 "Solution must be created first"
    Write-Host ""
    Write-Info "To create the solution:"
    Write-Host "1. Go to: https://make.powerapps.com" -ForegroundColor White
    Write-Host "2. Select your environment" -ForegroundColor White
    Write-Host "3. Click 'Solutions' > 'New solution'" -ForegroundColor White
    Write-Host "4. Name: $SolutionName" -ForegroundColor White
    Write-Host "5. Add components:" -ForegroundColor White
    Write-Host "   - Canvas App: Broadcast Notification App" -ForegroundColor White
    Write-Host "   - Cloud Flow: Send Broadcast Notification" -ForegroundColor White
    Write-Host "6. Run this script again" -ForegroundColor White
    Write-Host ""
    
    $openBrowser = Read-Host "Open Power Apps to create solution? (Y/N)"
    if ($openBrowser -eq 'Y' -or $openBrowser -eq 'y') {
        Start-Process "https://make.powerapps.com"
    }
    
    exit 0
}

# Export solution
Write-Info "Exporting solution..."
Write-Host ""

$exportType = if ($Managed) { "Managed" } else { "Unmanaged" }
Write-Info "Export type: $exportType"

$outputFile = Join-Path $ExportPath "$SolutionName`_$Version`_$exportType.zip"

try {
    if ($Managed) {
        pac solution export --name $SolutionName --path $outputFile --managed true
    } else {
        pac solution export --name $SolutionName --path $outputFile --managed false
    }
    
    Write-Host ""
    Write-Success "Solution exported successfully!"
    Write-Host ""
    Write-Info "Export location: $outputFile"
    Write-Info "File size: $((Get-Item $outputFile).Length / 1MB) MB"
    Write-Host ""
    
    Write-Host "Next Steps:" -ForegroundColor Green
    Write-Host "1. Upload to GitHub: Add to repository releases" -ForegroundColor White
    Write-Host "2. Share: Email or distribute the ZIP file" -ForegroundColor White
    Write-Host "3. Import: Others can import this into their environments" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Error2 "Export failed: $($_.Exception.Message)"
    Write-Host ""
    Write-Info "Try manual export:"
    Write-Host "1. Go to: https://make.powerapps.com" -ForegroundColor White
    Write-Host "2. Solutions > $SolutionName" -ForegroundColor White
    Write-Host "3. Click 'Export solution'" -ForegroundColor White
    Write-Host "4. Select export type and download" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Success "Export completed successfully!"
Write-Host ""
