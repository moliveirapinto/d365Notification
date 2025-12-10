# Distribution Package - Broadcast Notification System

## 📦 What's in This Package

This repository contains everything needed to deploy the Broadcast Notification System to any Dynamics 365 Customer Service environment.

## 🚀 Three Ways to Deploy

### Option 1: From Pre-Built Solution ZIP (If Available) ⚡

**If a solution ZIP file is available in GitHub Releases:**

1. Download `BroadcastNotification_Managed.zip` from [Releases](../../releases)
2. Go to https://make.powerapps.com
3. Select your environment
4. Solutions > Import solution
5. Upload the ZIP file
6. Follow the import wizard
7. Configure connections and security

**Time**: 10 minutes

---

### Option 2: Automated Deployment Script ⚡⚡

**Deploy from source using automated PowerShell:**

```powershell
cd DeploymentPackage
.\Deploy-BroadcastNotification.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -TenantId "your-tenant-id"
```

The script will guide you through:
- Installing prerequisites
- Creating Power Automate flow
- Building Canvas App
- Configuring security

**Time**: 15 minutes

See: [`ONE_CLICK_DEPLOY.md`](ONE_CLICK_DEPLOY.md)

---

### Option 3: Manual Step-by-Step

Follow the comprehensive guides:
- Quick: [`../QUICKSTART.md`](../QUICKSTART.md) - 30 minutes
- Detailed: [`../COMPLETE_GUIDE.md`](../COMPLETE_GUIDE.md) - 2 hours

---

## 🎯 How to Create a Distributable Solution ZIP

**For administrators who want to create a solution package:**

1. Deploy to your environment using Option 2 or 3
2. Create a solution container in Power Apps
3. Add all components to the solution
4. Export as managed solution
5. Share the ZIP file with others

**Automated export script:**
```powershell
.\Export-Solution.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -Managed
```

See: [`../SOLUTION_EXPORT_GUIDE.md`](../SOLUTION_EXPORT_GUIDE.md)

---

## 📥 Importing an Existing Solution

If someone has shared a solution ZIP with you:

```powershell
.\Import-Solution.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -SolutionFilePath ".\BroadcastNotification.zip"
```

Or import manually through Power Apps interface.

---

## 🗂️ Package Contents

```
DeploymentPackage/
├── README.md                           # This file
├── ONE_CLICK_DEPLOY.md                 # Quick deployment guide
├── Deploy-BroadcastNotification.ps1    # Automated deployment
├── Import-Solution.ps1                 # Import from ZIP
├── Export-Solution.ps1                 # Create distributable ZIP
├── Install-Prerequisites.ps1           # Module installer
├── Create-PowerAutomateFlow.ps1       # Flow creator
└── Configure-Security.ps1             # Security setup
```

---

## ⚙️ System Requirements

- Dynamics 365 Customer Service environment
- Power Apps license (included with D365)
- Power Automate license (included with D365)
- System Administrator role (for installation)
- PowerShell 5.1+ (for automated scripts)

---

## 🆘 Support

### If Automated Script Fails
Fall back to manual installation:
- [`../QUICKSTART.md`](../QUICKSTART.md) - Streamlined manual process
- [`../COMPLETE_GUIDE.md`](../COMPLETE_GUIDE.md) - Detailed instructions

### Documentation
- Architecture: [`../README.md`](../README.md)
- Security: [`../Security/SecurityGuide.md`](../Security/SecurityGuide.md)
- Troubleshooting: [`../COMPLETE_GUIDE.md#troubleshooting`](../COMPLETE_GUIDE.md#troubleshooting)

### Common Issues
- **"Cannot connect"**: Verify environment URL and admin access
- **"Module not found"**: Run as Administrator to install modules
- **Import fails**: Check environment version compatibility

---

## 📜 License

This solution is provided as-is for use in Dynamics 365 environments.

---

## 🌟 Version

**Current Version**: 1.0.0  
**Last Updated**: December 2025  
**Compatible with**: Dynamics 365 Customer Service (all versions)

---

## 💡 Tips for Distribution

### For Internal Teams
1. Clone this repository to internal Git
2. Run deployment script on test environment
3. Export solution and distribute ZIP
4. Document any custom configurations

### For External Sharing
1. Fork this repository
2. Deploy to your environment
3. Export managed solution
4. Upload to GitHub Releases
5. Share download link

### For AppSource (Future)
Consider packaging for Microsoft AppSource for wider distribution.

---

**Ready to Deploy?**

Choose your deployment method above and follow the instructions!
