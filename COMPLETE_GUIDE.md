# Broadcast Notification System - Complete Implementation Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Implementation Steps](#implementation-steps)
4. [Configuration](#configuration)
5. [Testing](#testing)
6. [Deployment](#deployment)
7. [User Guide](#user-guide)
8. [Troubleshooting](#troubleshooting)
9. [Maintenance](#maintenance)

---

## Overview

The Broadcast Notification System enables Customer Service Supervisors to send in-app notifications to Dynamics 365 users through an intuitive Canvas App interface accessible from the Customer Service Workspace.

### Key Features
- ✅ Send notifications to all users
- ✅ Send notifications to specific queue members
- ✅ Send notifications to selected users
- ✅ Character counter (500 character limit)
- ✅ Real-time delivery
- ✅ Integration with D365 notification center
- ✅ Clean, professional UI

### Architecture
```
┌─────────────────┐
│   Canvas App    │ ← User Interface
│  (Power Apps)   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Power Automate │ ← Business Logic
│      Flow       │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Dataverse     │ ← Data Storage
│  App Notify     │
└─────────────────┘
```

---

## Prerequisites

### Required Licenses
- Dynamics 365 Customer Service Enterprise
- Power Apps (included with D365)
- Power Automate (included with D365)

### Required Permissions
- System Administrator or System Customizer (for installation)
- Customer Service Supervisor (for usage)

### Environment Information
```
Environment: https://yourorg.crm.dynamics.com/
Tenant ID: your-tenant-id-here
App (Client) ID: your-client-id-here
Client Secret: your-client-secret-here
```

---

## Implementation Steps

### Phase 1: Create Power Automate Flow (30 minutes)

#### Step 1.1: Navigate to Power Automate
1. Go to https://make.powerautomate.com
2. Sign in with admin credentials
3. Select environment: **mauriciomaster**

#### Step 1.2: Create New Flow
1. Click **Create** → **Instant cloud flow**
2. Name: `Send Broadcast Notification`
3. Trigger: **PowerApps**
4. Click **Create**

#### Step 1.3: Add Input Parameters
Click on the PowerApps trigger and add inputs:

1. **Input 1**:
   - Name: `notificationType`
   - Type: Text
   - Description: `everyone, queue, or specific`
   - Required: Yes

2. **Input 2**:
   - Name: `message`
   - Type: Text
   - Description: `The notification message`
   - Required: Yes

3. **Input 3**:
   - Name: `queueId`
   - Type: Text
   - Description: `Queue GUID (optional)`
   - Required: No

4. **Input 4**:
   - Name: `userIds`
   - Type: Text
   - Description: `Comma-separated user GUIDs`
   - Required: No

#### Step 1.4: Build Flow Logic

Follow the complete flow structure in:
- **File**: `PowerAutomate/FlowSetupGuide.md`
- **JSON Definition**: `PowerAutomate/SendBroadcastNotification_Fixed.json`

**Quick Reference**:
1. Initialize variable: `UsersList` (Array)
2. Switch on `notificationType`
   - Case "everyone": List all active users
   - Case "queue": Get queue members
   - Case "specific": Split and get user IDs
3. Initialize variable: `SuccessCount` (Integer)
4. For each user: Create app notification
5. Respond to PowerApp with results

#### Step 1.5: Configure Dataverse Connection
1. When prompted, create Dataverse connection
2. Use your credentials or service account
3. Grant necessary permissions

#### Step 1.6: Save and Test
1. Click **Save**
2. Click **Test** → **Manually**
3. Enter test data:
   ```json
   {
     "notificationType": "everyone",
     "message": "Test notification"
   }
   ```
4. Click **Run flow**
5. Verify success

---

### Phase 2: Create Canvas App (45 minutes)

#### Step 2.1: Navigate to Power Apps
1. Go to https://make.powerapps.com
2. Select environment: **mauriciomaster**

#### Step 2.2: Create New Canvas App
1. Click **Create** → **Canvas app from blank**
2. Name: `Broadcast Notification App`
3. Format: **Tablet**
4. Click **Create**

#### Step 2.3: Add Data Sources
1. Click **Data** (cylinder icon) on left
2. Add **Tables**:
   - Search and add: `Queues`
   - Search and add: `Users` (systemusers)
3. Add **Power Automate**:
   - Click **Power Automate** in left menu
   - Add: `Send Broadcast Notification`

#### Step 2.4: Design the Interface

Use the complete design specifications in:
- **File**: `CanvasApp/DesignSpecifications.md`
- **Formulas**: `CanvasApp/PowerFxFormulas.txt`

**Quick Layout**:

1. **Header** (Y: 0-80):
   - Title label: "Send Broadcast Notification"
   - Icon

2. **Form Section** (Y: 100-650):
   - Dropdown: Notification Type
   - ComboBox: Queue (conditional)
   - ComboBox: Users (conditional)
   - TextInput: Message (multiline)
   - Label: Character counter
   - Button: Send
   - Button: Clear

3. **Info Section** (Y: 100-350):
   - Tips card
   - Preview card

#### Step 2.5: Add Controls

**Key Controls**:

1. **drpNotificationType** (Dropdown):
   ```powerFx
   Items: ["Everyone", "Specific Queue", "Specific Users"]
   Default: "Everyone"
   ```

2. **cmbQueue** (ComboBox):
   ```powerFx
   Items: SortByColumns(Filter(Queues, StateCode = 0), "Name", Ascending)
   Visible: drpNotificationType.Selected.Value = "Specific Queue"
   ```

3. **cmbUsers** (ComboBox):
   ```powerFx
   Items: SortByColumns(Filter(Users, 'Is Disabled' = false), "Full Name", Ascending)
   SelectMultiple: true
   Visible: drpNotificationType.Selected.Value = "Specific Users"
   ```

4. **txtMessage** (Text Input):
   ```powerFx
   Mode: TextMode.MultiLine
   MaxLength: 500
   HintText: "Enter your broadcast message here..."
   ```

5. **lblCharCount** (Label):
   ```powerFx
   Text: Len(txtMessage.Text) & " / 500 characters"
   Color: If(Len(txtMessage.Text) > 450, Red, If(Len(txtMessage.Text) > 400, Orange, Gray))
   ```

6. **btnSend** (Button):
   - See complete OnSelect formula in `CanvasApp/PowerFxFormulas.txt`
   - Calls the Power Automate flow
   - Handles response and errors

#### Step 2.6: Test in Play Mode
1. Click **Play** button (▶) in top right
2. Test each notification type
3. Verify validations work
4. Check character counter
5. Exit play mode (✕)

#### Step 2.7: Save and Publish
1. Click **File** → **Save**
2. Click **Publish**
3. Click **Publish this version**

---

### Phase 3: Configure Security (20 minutes)

Follow the complete guide in:
- **File**: `Security/SecurityGuide.md`

#### Step 3.1: Configure Security Role
1. Go to https://mauriciomaster.crm.dynamics.com
2. Settings → Security → Security Roles
3. Open **Customer Service Supervisor**
4. Set permissions:
   - App Notification: Create, Read, Write (Organization)
   - System User: Read (Organization)
   - Queue: Read (Organization/Business Unit)
5. Save and Close

#### Step 3.2: Share Canvas App
1. Go to https://make.powerapps.com
2. Apps → Broadcast Notification App
3. Click **...** → **Share**
4. Add users or security role: **Customer Service Supervisor**
5. Grant **User** permission
6. Check "Send email invitation"
7. Click **Share**

#### Step 3.3: Share Flow
1. Go to https://make.powerautomate.com
2. My flows → Send Broadcast Notification
3. Click **...** → **Share**
4. Add same users/groups as Canvas App
5. Click **Save**

---

### Phase 4: Integrate with Customer Service Workspace (15 minutes)

Follow the complete guide in:
- **File**: `SiteMap/IntegrationGuide.md`

#### Step 4.1: Get Canvas App URL
1. Go to https://make.powerapps.com
2. Apps → Broadcast Notification App
3. Click **...** → **Details**
4. Copy **Web link**
5. Save for next step

#### Step 4.2: Edit Customer Service Workspace
1. Go to https://make.powerapps.com
2. Apps → Find **Customer Service workspace**
3. Click **...** → **Edit**
4. Wait for App Designer to load

#### Step 4.3: Add to Site Map
1. In App Designer, click **Site Map**
2. Select existing Group or add new Group
3. Click **Add** → **Subarea**
4. Configure:
   - Type: **URL**
   - URL: [Paste Canvas App web link]
   - Title: **Broadcast Notifications**
   - Icon: Select notification icon
5. In Privileges section:
   - Add: App Notification - Create
   - Add: System User - Read

#### Step 4.4: Save and Publish
1. Click **Save**
2. Click **Publish**
3. Wait for publish to complete
4. Close App Designer

---

## Configuration

### Environment Variables
No environment variables required for basic operation.

### Optional Customizations

#### Change Message Length Limit
1. Open Canvas App in edit mode
2. Select `txtMessage` control
3. Change `MaxLength` property
4. Update character counter label
5. Save and publish

#### Change Notification Icon
In Power Automate flow, edit "Create App Notification":
- icontype values:
  - 100000000 = Info (default)
  - 100000001 = Success
  - 100000002 = Failure
  - 100000003 = Warning
  - 100000004 = Mention

#### Add Notification Expiration
In Power Automate flow, edit "Create App Notification":
- Add field: `expirydatetime`
- Set value: `addDays(utcNow(), 7)` (expires in 7 days)

---

## Testing

### Test Plan

#### Test Case 1: Send to Everyone
1. Open Customer Service Workspace
2. Click **Broadcast Notifications**
3. Select "Everyone"
4. Enter message: "Test to all users"
5. Click **Send Notification**
6. Verify success message
7. Check recipient notification center

**Expected Result**: All active users receive notification

#### Test Case 2: Send to Queue
1. Select "Specific Queue"
2. Choose a test queue
3. Enter message: "Test to queue members"
4. Click **Send**
5. Verify only queue members receive notification

**Expected Result**: Only queue members receive notification

#### Test Case 3: Send to Specific Users
1. Select "Specific Users"
2. Select 2-3 test users
3. Enter message: "Test to specific users"
4. Click **Send**
5. Verify only selected users receive notification

**Expected Result**: Only selected users receive notification

#### Test Case 4: Validation Tests
1. Try sending empty message → Should show error
2. Try sending to queue without selecting queue → Should show error
3. Try sending to specific users without selecting users → Should show error
4. Type 501 characters → Should be limited to 500

**Expected Result**: All validations work correctly

#### Test Case 5: Security Tests
1. Log in as regular user (non-supervisor)
2. Verify menu item is not visible
3. Try direct URL access → Should deny access
4. Log in as recipient → Verify can see received notifications

**Expected Result**: Security boundaries enforced

---

## Deployment

### Pre-Deployment Checklist
- [ ] Power Automate flow tested and working
- [ ] Canvas App tested in all modes
- [ ] Security roles configured
- [ ] Canvas App shared with users
- [ ] Flow shared with users
- [ ] Site map integrated
- [ ] Test notifications sent successfully
- [ ] User documentation prepared
- [ ] Training materials ready

### Deployment to Production

#### If Using Separate Dev Environment:

1. **Export Solution from Dev**:
   - Settings → Solutions
   - Create new solution
   - Add Canvas App
   - Add Power Automate flow
   - Add Security roles
   - Export as Managed

2. **Import to Production**:
   - Go to production environment
   - Settings → Solutions → Import
   - Select exported ZIP
   - Complete import wizard
   - Reconfigure connections

3. **Post-Import Steps**:
   - Share Canvas App with production users
   - Share flow with production users
   - Update site map with production app URL
   - Test in production

#### Direct Production Deployment:
If created directly in production, no export/import needed.

### Rollback Plan

If issues occur:

1. **Remove Site Map Entry**:
   - Hide menu item until fixed

2. **Disable Flow**:
   - Turn off Power Automate flow

3. **Unpublish Canvas App**:
   - Revert to previous version

4. **Delete Solution** (if imported):
   - Settings → Solutions → Delete

---

## User Guide

### For Supervisors

#### How to Send a Broadcast Notification

1. **Open Customer Service Workspace**
   - Navigate to your D365 environment
   - Launch Customer Service workspace

2. **Access Broadcast Notifications**
   - Look for "Broadcast Notifications" in the menu
   - Click to open

3. **Choose Notification Type**
   - **Everyone**: Sends to all active users in the organization
   - **Specific Queue**: Sends to members of a selected queue
   - **Specific Users**: Sends to manually selected users

4. **Select Recipients** (if applicable)
   - For Queue: Select queue from dropdown
   - For Specific Users: Check users from the list

5. **Compose Message**
   - Type your message in the text box
   - Keep under 500 characters
   - Watch the character counter

6. **Send**
   - Review your message
   - Click **Send Notification**
   - Wait for confirmation

7. **Done**
   - Success message will appear
   - Recipients will see notification immediately

#### Best Practices for Supervisors

**Do**:
- Keep messages clear and concise
- Include actionable information
- Use appropriate notification type for audience
- Proofread before sending
- Consider timing (avoid off-hours)

**Don't**:
- Send excessive notifications
- Include sensitive/confidential information
- Use for non-work-related messages
- Send to incorrect audiences
- Use ALL CAPS (shouting)

#### Example Messages

**System Maintenance**:
```
System maintenance scheduled for tonight at 10 PM EST. 
Please save your work before leaving. Downtime: 2 hours.
```

**Policy Update**:
```
New escalation policy effective immediately. 
All critical cases must be escalated within 1 hour. 
See knowledge base article KB-12345 for details.
```

**Recognition**:
```
Excellent work on customer satisfaction this quarter! 
Our team achieved 98% CSAT. Thank you for your dedication!
```

**Urgent Alert**:
```
URGENT: Major incident affecting Case Management. 
Use alternate process documented in Teams channel 
until further notice.
```

### For Recipients

#### How to View Notifications

1. **Notification Bell**:
   - Look for bell icon in D365 top bar
   - Number indicates unread notifications

2. **Open Notification Center**:
   - Click bell icon
   - View list of notifications

3. **Read Notification**:
   - Click notification to read full message
   - Notification marked as read

4. **Dismiss**:
   - Click X to dismiss
   - Or wait for auto-dismiss

#### Notification Settings

Users can manage notifications:
- Settings → Personalization Settings
- Notifications tab
- Configure preferences

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: Menu Item Not Visible
**Symptoms**: "Broadcast Notifications" doesn't appear in menu

**Solutions**:
1. Clear browser cache (Ctrl+Shift+Delete)
2. Sign out and sign back in
3. Verify security role assignment
4. Check if site map was published
5. Verify user has required privileges

**Verification**:
```
Settings → Security → Users → [User] → Manage Roles
Should see "Customer Service Supervisor"
```

#### Issue: Canvas App Doesn't Load
**Symptoms**: Blank screen or error when clicking menu item

**Solutions**:
1. Verify Canvas App URL in site map is correct
2. Check Canvas App is published
3. Verify user has access to Canvas App
4. Check Dataverse connection is active
5. Test Canvas App directly from Power Apps portal

**Verification**:
Open Canvas App directly: https://make.powerapps.com → Apps → Play

#### Issue: "Insufficient Privileges" Error
**Symptoms**: Error when trying to send notification

**Solutions**:
1. Verify Create privilege on App Notification (Organization level)
2. Check Read privilege on System User entity
3. Confirm security role is assigned
4. Wait 15 minutes for permission cache to refresh
5. Sign out and back in

**Verification**:
```
Settings → Security → Security Roles → Customer Service Supervisor
Core Records → App Notification → Create should be Organization (filled circle)
```

#### Issue: Can't Select Users or Queues
**Symptoms**: Dropdowns are empty

**Solutions**:
1. Verify Read privilege on System User
2. Verify Read privilege on Queue
3. Check if filters are excluding records
4. Verify Dataverse connection
5. Test query in Advanced Find

**Verification**:
Open Advanced Find → Search for Users and Queues

#### Issue: Notifications Not Received
**Symptoms**: Send succeeds but recipients don't see notification

**Solutions**:
1. Verify recipients have Read on App Notification (User level)
2. Check notification was created in Dataverse
3. Verify ownerid is set correctly
4. Check recipient notification settings
5. Verify recipient is active user

**Verification**:
```
Advanced Find → App Notifications
Filter by Created On = Today
Check if records exist
```

#### Issue: Flow Fails
**Symptoms**: Error in Power Automate flow run

**Solutions**:
1. Check flow run history for error details
2. Verify Dataverse connection is valid
3. Verify service account permissions (if using)
4. Check input parameters are correct format
5. Test each action individually

**Verification**:
Go to flow → 28-day run history → View failed runs

#### Issue: Character Counter Not Working
**Symptoms**: Counter doesn't update or shows wrong count

**Solutions**:
1. Verify formula in lblCharCount:
   ```powerFx
   Len(txtMessage.Text) & " / 500 characters"
   ```
2. Check if label is visible
3. Verify text input name is correct
4. Republish Canvas App

#### Issue: Performance Issues
**Symptoms**: App is slow to load or send

**Solutions**:
1. Optimize Dataverse queries (add filters)
2. Enable flow concurrency (max 5)
3. Reduce number of controls in app
4. Check environment performance
5. Consider pagination for large user lists

**Optimization**:
In flow, enable concurrency:
- For each loop → Settings → Concurrency Control → On → 5

#### Issue: Duplicate Notifications
**Symptoms**: Users receive same notification multiple times

**Solutions**:
1. Check flow isn't running multiple times
2. Verify no duplicate users in UsersList variable
3. Add deduplication logic to flow
4. Check for button double-click issue

**Prevention**:
In Canvas App, disable button during send:
```powerFx
DisplayMode: If(varIsLoading, Disabled, Edit)
```

---

## Maintenance

### Regular Maintenance Tasks

#### Weekly
- [ ] Review flow run history for errors
- [ ] Check for failed notifications
- [ ] Monitor notification volume

#### Monthly
- [ ] Review audit logs
- [ ] Check security role assignments
- [ ] Update user documentation if needed
- [ ] Review and optimize flow performance

#### Quarterly
- [ ] Review and update security permissions
- [ ] Gather user feedback
- [ ] Plan enhancements
- [ ] Test disaster recovery

### Monitoring

#### Key Metrics to Track
- Number of notifications sent per day
- Success vs. failure rate
- Flow execution time
- User adoption rate
- Error frequency

#### Monitoring Tools
1. **Power Automate Analytics**:
   - Go to flow → Analytics
   - View runs, errors, performance

2. **Canvas App Analytics**:
   - Go to app → Analytics
   - View usage, sessions, errors

3. **Dataverse Audit Logs**:
   - Settings → Auditing
   - Filter App Notification entity

### Backup and Recovery

#### Backup Components

**Weekly Backup**:
1. Export Canvas App (.msapp file)
2. Export Power Automate flow (JSON)
3. Export security role configuration
4. Export site map configuration

**Backup Procedure**:
```bash
1. Canvas App:
   - Open in edit mode
   - File → Save As → This Computer

2. Flow:
   - Open flow
   - Export (use export feature or copy JSON)

3. Security Roles:
   - Document current configuration
   - Take screenshots
```

#### Recovery Procedure

**If Canvas App Corrupted**:
1. Go to Power Apps → Apps → Broadcast Notification App
2. Click **...** → **Details**
3. Versions tab → Restore previous version
4. Or import backed up .msapp file

**If Flow Broken**:
1. Go to Power Automate → My flows
2. Turn off broken flow
3. Create new flow from backup JSON
4. Reconfigure connections
5. Test thoroughly
6. Update Canvas App to use new flow

**If Security Misconfigured**:
1. Go to Settings → Security → Security Roles
2. Edit role
3. Reapply saved configuration
4. Test with user account

### Updates and Enhancements

#### Planned Enhancements
- [ ] Rich text formatting in messages
- [ ] Scheduled notifications
- [ ] Notification templates
- [ ] Notification history view
- [ ] Read receipts/analytics
- [ ] Attachment support
- [ ] Multi-language support

#### Update Procedure
1. Create development copy of app/flow
2. Implement changes
3. Test thoroughly
4. Document changes
5. Schedule maintenance window
6. Deploy to production
7. Monitor post-deployment
8. Update documentation

### Support

#### Internal Support Contact
- Primary: IT Administrator
- Secondary: Power Platform Team
- Emergency: System Administrator

#### Microsoft Support
- Power Apps support: https://powerapps.microsoft.com/support/
- Power Automate support: https://flow.microsoft.com/support/
- Dynamics 365 support: https://dynamics.microsoft.com/support/

#### Useful Resources
- Power Apps documentation: https://docs.microsoft.com/powerapps/
- Power Automate documentation: https://docs.microsoft.com/power-automate/
- Dynamics 365 documentation: https://docs.microsoft.com/dynamics365/

---

## Appendix

### File Structure
```
d365Notification/
├── README.md
├── SOLUTION_GUIDE.md (this file)
├── QUICKSTART.md
├── deploy.sh
├── BroadcastNotificationSolution/
│   └── solution.xml
├── CanvasApp/
│   ├── BroadcastNotificationApp.msapp
│   ├── DesignSpecifications.md
│   └── PowerFxFormulas.txt
├── PowerAutomate/
│   ├── SendBroadcastNotification.json
│   ├── SendBroadcastNotification_Fixed.json
│   └── FlowSetupGuide.md
├── SiteMap/
│   ├── customcontroldefaultconfig.xml
│   ├── BroadcastNotificationsSiteMap.xml
│   └── IntegrationGuide.md
└── Security/
    ├── SecurityRoles.xml
    └── SecurityGuide.md
```

### Glossary

**Canvas App**: Power Apps application with custom UI
**Dataverse**: Microsoft's cloud database platform
**Power Automate**: Workflow automation platform
**Security Role**: Set of privileges in Dynamics 365
**Site Map**: Navigation structure in D365
**Subarea**: Menu item in D365 navigation
**App Notification**: D365 in-app notification entity

### Version History

**Version 1.0.0** (Initial Release)
- Basic broadcast notification functionality
- Three notification types: Everyone, Queue, Specific Users
- Canvas App with clean UI
- Power Automate integration
- Customer Service Workspace integration
- Security configuration
- Complete documentation

---

## Quick Reference

### URLs
- Power Apps: https://make.powerapps.com
- Power Automate: https://make.powerautomate.com
- D365 Environment: https://mauriciomaster.crm.dynamics.com

### Key Entities
- appnotification
- systemuser
- queue
- queuemembership

### Required Privileges
- App Notification: Create (Organization)
- System User: Read (Organization)
- Queue: Read (Organization)

### Support Files
All implementation files are in this repository at:
`/workspaces/d365Notification/`

---

**Document Version**: 1.0  
**Last Updated**: December 2025  
**Author**: Broadcast Notification System Implementation Team
