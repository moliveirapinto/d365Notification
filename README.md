# Broadcast Notification System for Dynamics 365 Customer Service

![D365](https://img.shields.io/badge/Dynamics%20365-Customer%20Service-0078D4?style=flat-square&logo=microsoft)
![Power Apps](https://img.shields.io/badge/Power%20Apps-Canvas-742774?style=flat-square)
![Power Automate](https://img.shields.io/badge/Power%20Automate-Flow-0066FF?style=flat-square)

A complete solution that enables Customer Service Supervisors to send broadcast notifications to Dynamics 365 users directly from the Customer Service Workspace.

---

## 🚀 Want to Create the Distributable ZIP File?

**[👉 3-Step Quick Guide: CREATE_ZIP_NOW.md](CREATE_ZIP_NOW.md)**

Deploy once (15 min) → Export (5 min) → Upload to GitHub (2 min) → Users install in 10 minutes!

---

## 🎯 Features

- **Multiple Notification Modes**
  - 📢 Notify all active users in the organization
  - 👥 Notify users in a specific service queue
  - 🎯 Notify specific selected users

- **User-Friendly Interface**
  - Simple text input with 500 character limit
  - Dynamic UI that adapts to selected notification type
  - Real-time character counter
  - Input validation and error handling

- **Seamless Integration**
  - Accessible from Customer Service Workspace menu
  - Uses native D365 in-app notifications
  - No custom entities required
  - Easy to deploy and maintain

## 📋 Prerequisites

- Dynamics 365 Customer Service environment
- Power Apps and Power Automate (included with D365)
- System Administrator access for installation
- Customer Service Supervisor role for usage

## 🚀 Quick Start

### ⚡ Install from Pre-Built Solution (If Available)

**If a solution ZIP is available in [Releases](../../releases):**

1. Download `BroadcastNotification_Managed.zip`
2. Go to https://make.powerapps.com → Solutions → Import
3. Upload the ZIP file and follow the wizard
4. Configure connections and security

**Time**: 10 minutes

---

### ⚡ Automated Deployment from Source

**Deploy using automated PowerShell script:**

```powershell
cd DeploymentPackage
.\Deploy-BroadcastNotification.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -TenantId "your-tenant-id"
```

The script will:
- ✅ Auto-install prerequisites
- ✅ Connect to your environment
- ⚠️ Guide you through flow creation (browser)
- ⚠️ Guide you through Canvas App setup (browser)
- ✅ Configure security automatically

**Time**: 15 minutes

**See**: [`DeploymentPackage/ONE_CLICK_DEPLOY.md`](DeploymentPackage/ONE_CLICK_DEPLOY.md) for detailed instructions

---

### 📖 Manual Installation (If automation fails)

#### Option 1: Quick Start (30 min)
See: [`QUICKSTART.md`](QUICKSTART.md)

#### Option 2: Step-by-Step (2 hours)

1. **Create the Power Automate Flow** (30 min)
   - See: [`PowerAutomate/FlowSetupGuide.md`](PowerAutomate/FlowSetupGuide.md)
   - Complete flow definition included

2. **Create the Canvas App** (45 min)
   - See: [`CanvasApp/DesignSpecifications.md`](CanvasApp/DesignSpecifications.md)
   - All formulas provided in: [`CanvasApp/PowerFxFormulas.txt`](CanvasApp/PowerFxFormulas.txt)

3. **Configure Security** (20 min)
   - See: [`Security/SecurityGuide.md`](Security/SecurityGuide.md)
   - Grant necessary privileges to supervisors

4. **Integrate with Customer Service Workspace** (15 min)
   - See: [`SiteMap/IntegrationGuide.md`](SiteMap/IntegrationGuide.md)
   - Add menu item to workspace

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [**COMPLETE_GUIDE.md**](COMPLETE_GUIDE.md) | 📚 Full implementation guide with all details |
| [**QUICKSTART.md**](QUICKSTART.md) | ⚡ Fast setup for experienced admins |
| [**CanvasApp/DesignSpecifications.md**](CanvasApp/DesignSpecifications.md) | 🎨 Complete UI design and layout |
| [**CanvasApp/PowerFxFormulas.txt**](CanvasApp/PowerFxFormulas.txt) | 🔧 All Power Fx formulas for the app |
| [**PowerAutomate/FlowSetupGuide.md**](PowerAutomate/FlowSetupGuide.md) | ⚙️ Step-by-step flow creation |
| [**Security/SecurityGuide.md**](Security/SecurityGuide.md) | 🔒 Complete security configuration |
| [**SiteMap/IntegrationGuide.md**](SiteMap/IntegrationGuide.md) | 🔗 Customer Service Workspace integration |

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  Customer Service Workspace              │
│                           Menu                           │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ↓
┌──────────────────────────────────────────────────────────┐
│              Broadcast Notification Canvas App           │
│  ┌────────────┐  ┌──────────────┐  ┌─────────────────┐  │
│  │ Everyone   │  │ Queue        │  │ Specific Users  │  │
│  │ Selector   │  │ Selector     │  │ Selector        │  │
│  └────────────┘  └──────────────┘  └─────────────────┘  │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Message Text Box (500 chars)                    │   │
│  └──────────────────────────────────────────────────┘   │
│                [Send]  [Clear]                           │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ↓
┌──────────────────────────────────────────────────────────┐
│          Power Automate Flow - Business Logic            │
│                                                          │
│  1. Receive Input (type, message, queue/users)          │
│  2. Query Dataverse for Recipients                       │
│     ├─ Everyone: All active users                        │
│     ├─ Queue: Queue members                              │
│     └─ Specific: Selected users                          │
│  3. Loop through Recipients                              │
│  4. Create App Notification for each                     │
│  5. Return Success + Count                               │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ↓
┌──────────────────────────────────────────────────────────┐
│              Microsoft Dataverse Tables                  │
│  ┌──────────────────┐  ┌──────────────────┐             │
│  │ App Notification │  │   System User    │             │
│  │    (Target)      │  │   (Recipients)   │             │
│  └──────────────────┘  └──────────────────┘             │
│  ┌──────────────────┐  ┌──────────────────┐             │
│  │     Queue        │  │ Queue Membership │             │
│  │                  │  │                  │             │
│  └──────────────────┘  └──────────────────┘             │
└──────────────────────────────────────────────────────────┘
                     │
                     ↓
┌──────────────────────────────────────────────────────────┐
│         Recipients' D365 Notification Center             │
│         🔔 Real-time In-App Notifications                │
└──────────────────────────────────────────────────────────┘
```

## 🎨 UI Preview

```
┌─────────────────────────────────────────────────────────────────┐
│  📢 Send Broadcast Notification                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Notification Type:  [Everyone               ▼]                │
│                                                                 │
│  Message: *                                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                                                         │   │
│  │  Enter your broadcast message here...                  │   │
│  │                                                         │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│  0 / 500 characters                                             │
│                                                                 │
│  [Send Notification]  [Clear]                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 🔒 Security

### Required Privileges for Supervisors
- **App Notification**: Create, Read, Write (Organization level)
- **System User**: Read (Organization level)
- **Queue**: Read (Organization/Business Unit level)

### For Recipients
- **App Notification**: Read (User level)

See complete security configuration in [`Security/SecurityGuide.md`](Security/SecurityGuide.md)

## 💡 Usage Examples

### Emergency Notification
```
URGENT: Major incident affecting Case Management system. 
Use alternate process until further notice. Check Teams 
channel for updates.
```

### Team Update
```
Great job on Q4 customer satisfaction! We achieved 98% CSAT. 
Thank you all for your dedication and hard work!
```

### System Maintenance
```
System maintenance tonight at 10 PM EST. Expected downtime: 
2 hours. Please save your work before leaving.
```

## 🔧 Customization

### Change Message Length Limit
Edit the `MaxLength` property of the text input control in the Canvas App.

### Change Notification Icon
In Power Automate flow, modify the `icontype` field:
- 100000000 = Info (default)
- 100000001 = Success
- 100000002 = Failure
- 100000003 = Warning
- 100000004 = Mention

### Add Message Templates
Create a dropdown with pre-defined messages for common scenarios.

### Add Scheduling
Add date/time picker and use "Delay until" action in the flow.

## 🧪 Testing

Test checklist included in [`COMPLETE_GUIDE.md`](COMPLETE_GUIDE.md#testing)

## 🐛 Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Menu item not visible | Clear cache, verify security role |
| Can't send notifications | Check Create privilege on App Notification |
| Users/Queues list empty | Verify Read privilege on entities |
| Notifications not received | Check recipient has Read on App Notification |

Full troubleshooting guide in [`COMPLETE_GUIDE.md`](COMPLETE_GUIDE.md#troubleshooting)

## 📦 Repository Structure

```
d365Notification/
├── README.md                          # This file
├── COMPLETE_GUIDE.md                  # Full implementation guide
├── QUICKSTART.md                      # Quick setup guide
├── DeploymentPackage/                 # ⚡ AUTOMATED DEPLOYMENT
│   ├── ONE_CLICK_DEPLOY.md           # Automated deployment guide
│   ├── Deploy-BroadcastNotification.ps1 # Main deployment script
│   ├── Install-Prerequisites.ps1      # Module installer
│   ├── Create-PowerAutomateFlow.ps1  # Flow creator
│   └── Configure-Security.ps1        # Security configurator
├── BroadcastNotificationSolution/
│   └── solution.xml                   # Solution manifest
├── CanvasApp/
│   ├── BroadcastNotificationApp.msapp # App placeholder
│   ├── DesignSpecifications.md        # Complete UI design
│   └── PowerFxFormulas.txt            # All Power Fx formulas
├── PowerAutomate/
│   ├── SendBroadcastNotification.json # Flow definition (reference)
│   ├── SendBroadcastNotification_Fixed.json # Complete flow JSON
│   └── FlowSetupGuide.md              # Step-by-step flow setup
├── SiteMap/
│   ├── customcontroldefaultconfig.xml # Sitemap config
│   ├── BroadcastNotificationsSiteMap.xml # Sitemap entry
│   └── IntegrationGuide.md            # Integration instructions
└── Security/
    ├── SecurityRoles.xml              # Security role template
    └── SecurityGuide.md               # Complete security setup
```

## 🤝 Contributing

This solution is designed for internal use. Customize as needed for your organization.

## 📄 License

This solution is provided as-is for use in your Dynamics 365 environment.

## 📞 Support

For implementation assistance:
1. Review the [`COMPLETE_GUIDE.md`](COMPLETE_GUIDE.md)
2. Check [`Troubleshooting`](COMPLETE_GUIDE.md#troubleshooting) section
3. Contact your Dynamics 365 administrator
4. Reach out to your Power Platform team

## 🌟 Features Roadmap

Future enhancements:
- [ ] Rich text formatting
- [ ] Scheduled notifications
- [ ] Message templates library
- [ ] Notification history viewer
- [ ] Read receipts and analytics
- [ ] Attachment support
- [ ] Multi-language support
- [ ] Mobile app optimization

## 🎓 Learn More

- [Power Apps Documentation](https://docs.microsoft.com/powerapps/)
- [Power Automate Documentation](https://docs.microsoft.com/power-automate/)
- [Dynamics 365 Customer Service](https://docs.microsoft.com/dynamics365/customer-service/)

## 👥 Target Users

**Primary Users (Senders)**:
- Customer Service Supervisors
- Team Leads
- Service Managers

**Secondary Users (Recipients)**:
- Customer Service Representatives
- Support Agents
- All D365 Users

---

**Version**: 1.0.0  
**Environment**: Dynamics 365 Customer Service  
**Platform**: Power Platform (Power Apps + Power Automate)  
**Last Updated**: December 2025

---

## 🚀 Get Started Now

### Option 1: Pre-Built Solution ⚡⚡⚡ (Fastest)
Check [Releases](../../releases) for downloadable solution ZIP

**Time**: 10 minutes | **Skill**: Basic

### Option 2: Automated Script ⚡⚡ (Recommended)
```powershell
cd DeploymentPackage
.\Deploy-BroadcastNotification.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -TenantId "your-tenant-id"
```
**Time**: 15 minutes | **Skill**: Basic PowerShell

See: [`DeploymentPackage/ONE_CLICK_DEPLOY.md`](DeploymentPackage/ONE_CLICK_DEPLOY.md)

### Option 3: Manual Setup ⚡
1. Quick: [`QUICKSTART.md`](QUICKSTART.md) - 30 minutes
2. Detailed: [`COMPLETE_GUIDE.md`](COMPLETE_GUIDE.md) - 2 hours

---

## 📤 Creating Your Own Solution Package

Want to create a distributable ZIP file?

1. Deploy to your environment (use Option 2 or 3 above)
2. Export as solution using our script:
   ```powershell
   .\DeploymentPackage\Export-Solution.ps1 -EnvironmentUrl "https://yourorg.crm.dynamics.com" -Managed
   ```
3. Share the ZIP file with others or upload to GitHub Releases

**See**: [`RELEASE_GUIDE.md`](RELEASE_GUIDE.md) for complete instructions on creating and publishing releases

---

*Built with ❤️ for the Dynamics 365 Community*