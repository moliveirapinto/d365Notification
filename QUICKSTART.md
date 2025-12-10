# Quick Start Guide - Broadcast Notification System

## For System Administrators

### Installation Steps (15 minutes)

1. **Create Power Automate Flow**
   - Go to https://make.powerautomate.com
   - Sign in with your credentials for mauriciomaster.crm.dynamics.com
   - Create flow (detailed in SOLUTION_GUIDE.md Step 1)
   - Test the flow

2. **Create Canvas App**
   - Go to https://make.powerapps.com
   - Create Canvas app (detailed in SOLUTION_GUIDE.md Step 2)
   - Connect to the flow
   - Publish the app

3. **Configure Security**
   - Add Create privilege on appnotification to Customer Service Supervisor role
   - Assign users to the role

4. **Add to Menu**
   - Add Canvas App link to Customer Service Workspace sitemap

## For Supervisors

### How to Send Notifications

1. **Open the App**
   - Go to Customer Service Workspace
   - Click "Broadcast Notifications" in the menu

2. **Choose Recipients**
   - Everyone: All active users
   - Specific Queue: Select a queue
   - Specific Users: Pick individual users

3. **Type Message**
   - Enter your message (up to 500 characters)
   - Review the character count

4. **Send**
   - Click "Send Notification"
   - Wait for confirmation

## Authentication Setup

Use your own credentials in your Power Platform connections:

- **Environment**: https://yourorg.crm.dynamics.com/
- **App ID**: your-client-id-here
- **Tenant ID**: your-tenant-id-here
- **Client Secret**: your-client-secret-here

**Note**: Use these when creating Dataverse connections in Power Automate and Power Apps.

## Testing Checklist

- [ ] Flow runs successfully
- [ ] App connects to flow
- [ ] Can send to everyone
- [ ] Can send to queue
- [ ] Can send to specific users
- [ ] Notifications appear in D365
- [ ] Clear button works
- [ ] Character counter works
- [ ] Appears in CS Workspace menu

## Common Use Cases

### Emergency Notification
"System maintenance in 15 minutes. Please save your work."

### Team Update
"New escalation policy effective immediately. Check the wiki for details."

### Recognition
"Great job on the Q4 customer satisfaction scores, team!"

### Reminder
"Reminder: Weekly team meeting starts in 30 minutes in the main conference room."
