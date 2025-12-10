# How to Create and Publish a Solution Release

## 📦 Creating Your First Release

Follow these steps to create a distributable solution ZIP and publish it on GitHub.

### Step 1: Deploy to Your Test Environment

First, get the solution working in your own environment:

```powershell
cd DeploymentPackage
.\Deploy-BroadcastNotification.ps1 `
    -EnvironmentUrl "https://mauriciomaster.crm.dynamics.com" `
    -TenantId "48ac8550-da32-403e-9d2c-d280efe32983"
```

Test everything to ensure it works properly.

---

### Step 2: Create the Solution in Power Platform

1. **Go to Power Apps**
   - Navigate to https://make.powerapps.com
   - Select your environment

2. **Create Solution**
   - Click **Solutions** > **New solution**
   - **Display name**: Broadcast Notification System
   - **Name**: BroadcastNotification
   - **Publisher**: Create or select a publisher
     - **Display name**: Your Organization
     - **Name**: yourorg
     - **Prefix**: new
   - **Version**: 1.0.0.0
   - Click **Create**

3. **Add Components**
   - Open the solution
   - Click **Add existing** > **More** > **Canvas app**
   - Select "Broadcast Notification App" > **Add**
   - Click **Add existing** > **Automation** > **Cloud flow**
   - Select "Send Broadcast Notification" > **Add**

---

### Step 3: Export the Solution

#### Option A: Using PowerShell Script (Recommended)

```powershell
.\Export-Solution.ps1 `
    -EnvironmentUrl "https://mauriciomaster.crm.dynamics.com" `
    -SolutionName "BroadcastNotification" `
    -Version "1.0.0.0" `
    -Managed
```

The script will create: `BroadcastNotification_1.0.0.0_Managed.zip`

#### Option B: Manual Export

1. In Power Apps, go to **Solutions**
2. Select **BroadcastNotification**
3. Click **Export solution**
4. Click **Next**
5. Choose **Managed** for distribution
6. Click **Export**
7. Download the ZIP file when ready

---

### Step 4: Create GitHub Release

1. **Go to GitHub Repository**
   - Navigate to https://github.com/moliveirapinto/d365Notification

2. **Create New Release**
   - Click **Releases** > **Create a new release**
   - **Tag version**: v1.0.0
   - **Release title**: Broadcast Notification System v1.0.0
   - **Description**: Copy from template below

3. **Upload Solution ZIP**
   - Drag and drop: `BroadcastNotification_1.0.0.0_Managed.zip`
   - Optionally also upload unmanaged version for developers

4. **Publish Release**
   - Click **Publish release**

---

### Step 5: Update README

Add a download badge to the README:

```markdown
## 📥 Quick Install

Download the latest solution:

[![Download Latest Release](https://img.shields.io/github/v/release/moliveirapinto/d365Notification?label=Download%20Solution)](https://github.com/moliveirapinto/d365Notification/releases/latest)

**Installation**: Download the ZIP and import to your D365 environment
```

---

## 📝 Release Description Template

Use this template for your GitHub release description:

```markdown
# Broadcast Notification System v1.0.0

Send broadcast notifications to Dynamics 365 users directly from Customer Service Workspace.

## 🎯 Features

- ✅ Notify all active users
- ✅ Notify users in a specific queue
- ✅ Notify specific selected users
- ✅ Simple text input with character limit
- ✅ Real-time D365 in-app notifications

## 📥 Installation

### Quick Install (10 minutes)

1. Download `BroadcastNotification_1.0.0.0_Managed.zip` below
2. Go to https://make.powerapps.com
3. Select your environment
4. Navigate to **Solutions** > **Import solution**
5. Upload the ZIP file
6. Follow the import wizard
7. Configure connections when prompted
8. Share Canvas App with users
9. Configure security roles (see documentation)

### Detailed Documentation

- [Complete Installation Guide](https://github.com/moliveirapinto/d365Notification/blob/main/COMPLETE_GUIDE.md)
- [Quick Start Guide](https://github.com/moliveirapinto/d365Notification/blob/main/QUICKSTART.md)
- [Security Configuration](https://github.com/moliveirapinto/d365Notification/blob/main/Security/SecurityGuide.md)

## 📋 Requirements

- Dynamics 365 Customer Service environment
- System Administrator access (for installation)
- Power Apps and Power Automate licenses (included with D365)

## 🔐 Security Configuration Required

After import, configure security roles:
- Grant **Create** privilege on **App Notification** to Customer Service Supervisor role
- See detailed guide: [Security/SecurityGuide.md](https://github.com/moliveirapinto/d365Notification/blob/main/Security/SecurityGuide.md)

## 📦 What's Included

- ✅ Canvas App: Broadcast Notification App
- ✅ Power Automate Flow: Send Broadcast Notification
- ✅ All required configurations

## 🆘 Support

- [Troubleshooting Guide](https://github.com/moliveirapinto/d365Notification/blob/main/COMPLETE_GUIDE.md#troubleshooting)
- [GitHub Issues](https://github.com/moliveirapinto/d365Notification/issues)

## 📜 Version History

**Version 1.0.0** (December 2025)
- Initial release
- Core broadcast notification functionality
- Three notification modes
- Customer Service Workspace integration

---

## 📥 Downloads

Choose the appropriate file:

- **BroadcastNotification_1.0.0.0_Managed.zip** - For production use (recommended)
- **BroadcastNotification_1.0.0.0_Unmanaged.zip** - For development/customization

---

**Installation Time**: ~10 minutes  
**Skill Level**: Basic Power Platform knowledge
```

---

## 🔄 Creating Future Releases

### For Version 1.1.0, 1.2.0, etc.

1. **Update version in solution**
   - In Power Apps > Solutions > BroadcastNotification
   - Click settings > Update version number

2. **Make your changes**
   - Update Canvas App
   - Modify flows
   - Test thoroughly

3. **Export new version**
   ```powershell
   .\Export-Solution.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -Version "1.1.0" -Managed
   ```

4. **Create new GitHub release**
   - Tag: v1.1.0
   - Document changes in release notes
   - Upload new ZIP file

---

## 📊 Release Checklist

Before creating a release:

- [ ] Solution deployed and tested in dev environment
- [ ] All components working correctly
- [ ] Documentation updated
- [ ] Version number incremented
- [ ] Solution exported as managed
- [ ] ZIP file tested in clean environment
- [ ] Release notes prepared
- [ ] Screenshots updated (if UI changed)

---

## 🎯 Distribution Options

### Option 1: GitHub Releases (Recommended)
- ✅ Version control
- ✅ Download statistics
- ✅ Release notes
- ✅ Public or private

### Option 2: Internal Repository
- Clone to internal Git/Azure DevOps
- Distribute via internal package manager

### Option 3: AppSource
- For public distribution
- Microsoft certification required
- Broader reach

---

## 💡 Tips

1. **Always test exports** - Import the exported ZIP into a clean environment before publishing
2. **Use managed solutions** - For production distribution
3. **Keep unmanaged versions** - For development and customization
4. **Document breaking changes** - Clearly communicate in release notes
5. **Version consistently** - Follow semantic versioning (Major.Minor.Patch)

---

## 🔒 Important Notes

**Cannot Pre-Package**: Power Platform solutions CANNOT be manually created as ZIP files. They MUST be:
1. Built in a real environment
2. Exported using Power Platform tools
3. Then distributed

This is why the deployment scripts exist - to help users create the components that can then be exported.

---

**Ready to Create Your First Release?**

Follow the steps above and you'll have a distributable solution package ready to share!
