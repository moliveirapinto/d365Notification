# Broadcast Notification System - Automated Deployment

## Overview
This package contains scripts to automatically deploy the Broadcast Notification System to any Dynamics 365 Customer Service environment.

## What Gets Deployed

1. ✅ Power Automate Flow (Send Broadcast Notification)
2. ✅ Canvas App (Broadcast Notification App) - *Requires manual creation with provided template*
3. ✅ Security Role Configuration
4. ✅ Sitemap Integration

## Prerequisites

- PowerShell 5.1 or higher
- Dynamics 365 Customer Service environment
- System Administrator access
- Power Apps and Power Automate licenses

## Quick Deploy

### Option 1: Automated PowerShell Script (Recommended)

```powershell
# Run the deployment script
.\Deploy-BroadcastNotification.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -TenantId "your-tenant-id"
```

### Option 2: Manual Import (If automation fails)

Follow the guides in:
- `QUICKSTART.md` - Fast manual setup
- `COMPLETE_GUIDE.md` - Detailed manual setup

## Deployment Steps

The automated script will:
1. ✅ Connect to your D365 environment
2. ✅ Create Power Automate flow from template
3. ✅ Configure security roles
4. ⚠️ Guide you through Canvas App creation (must be done in browser)
5. ✅ Update sitemap configuration

## What You Need to Do Manually

Due to Power Platform limitations, you must create the Canvas App manually:

1. The script will open Power Apps in your browser
2. Follow the on-screen wizard
3. The app will be pre-configured with all controls and formulas
4. Click "Create" and the script will continue

**Time Required**: 10 minutes guided setup

## Package Contents

```
DeploymentPackage/
├── Deploy-BroadcastNotification.ps1    # Main deployment script
├── Install-Prerequisites.ps1            # Installs required PowerShell modules
├── Create-PowerAutomateFlow.ps1        # Creates the flow
├── Configure-Security.ps1               # Sets up security roles
├── Update-Sitemap.ps1                   # Adds to CS Workspace
├── Templates/
│   ├── FlowDefinition.json             # Flow template
│   ├── CanvasAppTemplate.json          # Canvas App config
│   └── SecurityRoleConfig.json         # Security settings
└── README.md                            # This file
```

## Support

If automated deployment fails, use manual installation:
- See: `COMPLETE_GUIDE.md` in parent directory
- Or: `QUICKSTART.md` for experienced admins

## Rollback

To remove the solution:
```powershell
.\Rollback-BroadcastNotification.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com"
```

## Version

**Version**: 1.0.0  
**Last Updated**: December 2025
