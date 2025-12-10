# ONE-CLICK DEPLOYMENT GUIDE

## ⚡ Fastest Deployment Method

### What You'll Get
A **semi-automated deployment** that creates 80% of the solution automatically, with guided manual steps for the remaining 20% (due to Power Platform API limitations).

### Time Required
- **Automated**: 5 minutes
- **Guided Manual**: 10 minutes
- **Total**: 15 minutes

---

## 🚀 Quick Deploy Instructions

### Step 1: Download and Extract
You already have all the files. You're ready to go!

### Step 2: Open PowerShell as Administrator
```powershell
# Navigate to the deployment folder
cd /workspaces/d365Notification/DeploymentPackage

# Set execution policy (if needed)
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### Step 3: Run Deployment Script
```powershell
.\Deploy-BroadcastNotification.ps1 `
    -EnvironmentUrl "https://mauriciomaster.crm.dynamics.com" `
    -TenantId "48ac8550-da32-403e-9d2c-d280efe32983"
```

### Step 4: Follow On-Screen Instructions
The script will:
- ✅ Auto-install PowerShell modules
- ✅ Connect to your environment  
- ⚠️ Guide you through Power Automate flow creation (opens browser)
- ✅ Configure security roles
- ⚠️ Guide you through Canvas App creation (opens browser)
- ℹ️ Provide sitemap integration instructions

---

## 🎯 What Happens During Deployment

### Automated Steps (No Action Required)
1. ✅ Prerequisites check
2. ✅ PowerShell module installation
3. ✅ Environment connection
4. ✅ Security role configuration

### Guided Steps (Follow On-Screen Prompts)
5. ⚠️ **Power Automate Flow** (5 min)
   - Script opens browser to Power Automate
   - You click "Create" and follow template
   - Script provides step-by-step guidance

6. ⚠️ **Canvas App** (5 min)
   - Script opens Power Apps in browser
   - You create app from blank
   - Copy/paste provided formulas
   - Script continues when done

7. ℹ️ **Sitemap Integration** (manual)
   - Run additional script after Canvas App URL is available

---

## 📋 Alternative: 100% Manual (If Script Fails)

If the PowerShell script doesn't work in your environment:

### Option A: Quick Start Guide (30 min)
Follow: [`QUICKSTART.md`](../QUICKSTART.md)

### Option B: Complete Guide (2 hours)
Follow: [`COMPLETE_GUIDE.md`](../COMPLETE_GUIDE.md)

---

## 🔧 Troubleshooting Deployment Script

### Issue: "Execution Policy" Error
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

### Issue: "Cannot connect to environment"
- Verify environment URL is correct
- Ensure you have System Administrator access
- Try interactive authentication (remove -ClientId/-ClientSecret)

### Issue: PowerShell modules won't install
- Run PowerShell as Administrator
- Manually install:
  ```powershell
  Install-Module -Name Microsoft.Xrm.Data.PowerShell -Scope CurrentUser -Force
  ```

### Issue: Script hangs or fails
- Press Ctrl+C to cancel
- Use manual installation method instead
- See: `QUICKSTART.md`

---

## ✅ Post-Deployment Checklist

After running the deployment script:

- [ ] Power Automate flow created and turned on
- [ ] Flow tested successfully
- [ ] Canvas App created and published
- [ ] Canvas App shared with supervisors
- [ ] Security roles configured
- [ ] Sitemap updated with Canvas App URL
- [ ] Test notification sent successfully

---

## 🆘 Need Help?

1. **Check script output** - Look for error messages
2. **Review logs** - Check PowerShell transcript
3. **Fall back to manual** - Use `QUICKSTART.md` or `COMPLETE_GUIDE.md`
4. **Check prerequisites** - Ensure you have admin access

---

## 📦 What Gets Installed

| Component | Method | Time |
|-----------|--------|------|
| Power Automate Flow | Guided | 5 min |
| Canvas App | Guided | 5 min |
| Security Roles | Automated | 1 min |
| Sitemap Entry | Manual script | 2 min |

**Total: ~15 minutes**

---

## 🎓 For Advanced Users

### Unattended Deployment (Service Principal)
```powershell
.\Deploy-BroadcastNotification.ps1 `
    -EnvironmentUrl "https://yourorg.crm.dynamics.com" `
    -TenantId "your-tenant-id" `
    -ClientId "your-app-id" `
    -ClientSecret "your-secret" `
    -SkipCanvasApp
```

Then create Canvas App manually later.

### Deployment to Multiple Environments
```powershell
# Export after first deployment
Export-CrmSolution -SolutionName "BroadcastNotification"

# Import to other environments
Import-CrmSolution -SolutionFilePath "BroadcastNotification.zip"
```

---

**Ready to Deploy?**

Run the deployment script now:
```powershell
.\Deploy-BroadcastNotification.ps1 -EnvironmentUrl "https://mauriciomaster.crm.dynamics.com" -TenantId "48ac8550-da32-403e-9d2c-d280efe32983"
```
