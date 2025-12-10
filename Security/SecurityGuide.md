# Security Configuration Guide

## Overview
This guide details the security configuration required for the Broadcast Notification System.

## Security Roles

### Required Roles

#### 1. Customer Service Supervisor (Senders)
Users who will send broadcast notifications need this role or equivalent.

**Required Privileges**:

| Entity | Privilege | Level | Purpose |
|--------|-----------|-------|---------|
| App Notification | Create | Organization | Send notifications to any user |
| App Notification | Read | Organization | View sent notifications |
| App Notification | Write | Organization | Modify notification if needed |
| System User | Read | Organization | List and select users |
| Queue | Read | Organization | List and select queues |
| Queue Membership | Read | Organization | Get queue members |

#### 2. Basic User (Recipients)
All users who will receive notifications need basic access.

**Required Privileges**:

| Entity | Privilege | Level | Purpose |
|--------|-----------|-------|---------|
| App Notification | Read | User | View their own notifications |

## Step-by-Step Configuration

### Configure Customer Service Supervisor Role

1. **Navigate to Security Settings**
   - Go to https://mauriciomaster.crm.dynamics.com
   - Click Settings (gear icon) → Advanced Settings
   - Go to **Settings** → **Security** → **Security Roles**

2. **Edit Customer Service Supervisor Role**
   - Find and click "Customer Service Supervisor"
   - Or create a new role: "Broadcast Notification Sender"

3. **Set Business Management Tab Permissions**
   
   Scroll to **Business Management** tab:
   
   **User** entity:
   - Create: ○ (None)
   - Read: ● (Organization)
   - Write: ○ (None)
   - Delete: ○ (None)
   - Append: ○ (None)
   - Append To: ○ (None)
   - Assign: ○ (None)
   - Share: ○ (None)

4. **Set Service Tab Permissions**
   
   Scroll to **Service** tab:
   
   **Queue** entity:
   - Create: ○ (None)
   - Read: ● (Organization) or ◐ (Business Unit) minimum
   - Write: ○ (None)
   - Delete: ○ (None)
   - Append: ○ (None)
   - Append To: ○ (None)
   - Assign: ○ (None)
   - Share: ○ (None)

5. **Set Core Records Tab Permissions**
   
   Scroll to **Core Records** tab:
   
   **App Notification** entity:
   - Create: ● (Organization)
   - Read: ● (Organization)
   - Write: ● (Organization)
   - Delete: ○ (None) or ◐ (Business Unit)
   - Append: ○ (None)
   - Append To: ○ (None)
   - Assign: ○ (None)
   - Share: ○ (None)

6. **Save the Role**
   - Click **Save and Close**

### Configure Basic User Role

The **Basic User** role typically already has Read access to App Notification at User level. Verify:

1. **Open Basic User Role**
   - Settings → Security → Security Roles
   - Open "Basic User" role

2. **Verify Core Records Tab**
   
   **App Notification** entity:
   - Read: At least ◑ (User) level
   
   If not set:
   - Click on Read privilege for App Notification
   - Set to User level (yellow circle)

3. **Save the Role**

## Privilege Levels Explained

| Symbol | Level | Description |
|--------|-------|-------------|
| ○ | None | No access |
| ◑ | User | Access to own records only |
| ◐ | Business Unit | Access to records in user's business unit |
| ◕ | Parent: Child Business Units | Access to records in user's BU and child BUs |
| ● | Organization | Access to all records |

## Canvas App Security

### Share the Canvas App

1. **Navigate to Power Apps**
   - Go to https://make.powerapps.com
   - Select **Apps**

2. **Share the Broadcast Notification App**
   - Find "Broadcast Notification App"
   - Click three dots (...) → **Share**

3. **Add Users or Groups**
   - Search for "Customer Service Supervisor" security role
   - Or add individual users/groups
   - Grant **User** permission (not Co-owner)

4. **Share Connections**
   - Ensure "Share with users" is checked for:
     - Dataverse connection
     - Power Automate flow connection

5. **Send Email Notification**
   - Check "Send an email invitation"
   - Click **Share**

## Power Automate Flow Security

### Share the Flow

1. **Navigate to Power Automate**
   - Go to https://make.powerautomate.com
   - Select **My flows**

2. **Share Send Broadcast Notification Flow**
   - Find "Send Broadcast Notification"
   - Click three dots (...) → **Share**

3. **Add Users**
   - Add users or security groups
   - Grant **User** permission

4. **Verify Connections**
   - Ensure Dataverse connection uses a service account or shared connection
   - Or ensure each user creates their own connection

## Connection References

### Option 1: Embedded Connections (Default)
- Each user's connection is used
- User's security context applies
- No additional setup needed

### Option 2: Service Account Connection
For enterprise deployments:

1. **Create Service Account**
   - Create dedicated user: "D365 Notification Service"
   - Assign appropriate security role
   - License the account

2. **Create Connection as Service Account**
   - Sign in as service account
   - Create Dataverse connection
   - Create flow with this connection

3. **Share Flow**
   - Share flow with users
   - Users run flow under service account context

**Pros**:
- Consistent security context
- Centralized audit trail
- Users don't need elevated privileges

**Cons**:
- Requires additional license
- Less granular auditing
- Potential security concern

### Option 3: Connection References in Solution
For managed solutions:

1. **Export as Managed Solution**
2. **Include Connection References**
3. **Users map to their connections on import**

## Testing Security

### Test as Supervisor

1. **Assign Test User to Supervisor Role**
   - Settings → Security → Users
   - Select test user
   - Manage Roles → Add "Customer Service Supervisor"

2. **Test Sending Notifications**
   - Log in as test user
   - Open Broadcast Notification App
   - Try sending to:
     - Everyone
     - Specific queue
     - Specific users

3. **Verify Success**
   - Notifications should be created
   - Recipients should see notifications

### Test as Regular User

1. **Assign Test User to Basic Role Only**
   - Remove any elevated roles
   - Keep only "Basic User" role

2. **Test Receiving Notifications**
   - Have supervisor send notification to this user
   - Log in as regular user
   - Check notification center
   - Verify notification appears

3. **Test Access Restrictions**
   - Regular user should NOT see Broadcast Notification App
   - Regular user should NOT be able to send notifications

### Test Permission Boundaries

**Test Case 1: User without Create Privilege**
- Remove Create on App Notification
- Try to send notification
- Should fail with permission error

**Test Case 2: User without Read on System User**
- Remove Read on System User
- Try to select specific users
- Should not see user list

**Test Case 3: User without Queue Read**
- Remove Read on Queue
- Try to select queue
- Should not see queue list

## Field-Level Security

If you need to restrict certain notification fields:

1. **Navigate to Field Security**
   - Settings → Customizations → Customize the System
   - Expand **Entities** → **App Notification** → **Fields**

2. **Enable Field Security**
   - Select field (e.g., "Owner")
   - Click **Edit**
   - Check "Enable Security"
   - Save and Publish

3. **Create Field Security Profile**
   - Settings → Security → Field Security Profiles
   - Create new profile
   - Add field with appropriate permissions
   - Assign to users

## Audit and Compliance

### Enable Auditing

1. **Enable Entity Audit**
   - Settings → Customizations → Customize the System
   - Expand **Entities** → **App Notification**
   - Check "Auditing" → "Single record auditing"
   - Save and Publish

2. **Enable User Audit**
   - Settings → Administration → System Settings
   - **Auditing** tab
   - Check "Start Auditing"
   - Select entities to audit

3. **View Audit Logs**
   - Settings → Auditing → Audit Summary View
   - Filter by entity, user, date
   - Export audit logs if needed

### Compliance Considerations

**Data Retention**:
- Set retention policies for App Notification records
- Consider archiving old notifications

**Privacy**:
- Ensure notifications don't contain PII
- Train supervisors on appropriate messaging

**Access Logging**:
- Monitor who sends notifications
- Track notification volume
- Review for abuse

## Common Security Issues

### Issue: Users can't see the app
**Solution**:
- Verify app is shared with users
- Check security role assignment
- Confirm user has Read on App Notification

### Issue: "Insufficient privileges" when sending
**Solution**:
- Verify Create privilege on App Notification at Organization level
- Check if security role is assigned correctly
- Ensure user has Read on System User entity

### Issue: Can't select users or queues
**Solution**:
- Grant Read privilege on System User entity
- Grant Read privilege on Queue entity
- Check if user list is filtered by security

### Issue: Flow fails with permission error
**Solution**:
- Check flow connection is valid
- Verify service account has appropriate permissions
- Ensure user has access to flow

### Issue: Recipients don't see notifications
**Solution**:
- Verify recipients have Read on App Notification (User level)
- Check if notification owner is set correctly
- Ensure notifications are not being filtered

## Best Practices

1. **Principle of Least Privilege**
   - Grant only necessary permissions
   - Don't give Organization-level access unless needed
   - Regularly review and audit permissions

2. **Use Security Groups**
   - Create Azure AD groups for notification senders
   - Assign roles to groups, not individuals
   - Easier to manage as team changes

3. **Separate Roles**
   - Consider separate "Notification Sender" role
   - Don't reuse existing roles if possible
   - Clearer audit trail

4. **Document Access**
   - Maintain list of users with send privileges
   - Document business justification
   - Review quarterly

5. **Test Before Production**
   - Test all permission scenarios in dev environment
   - Use test users, not admin accounts
   - Document test results

6. **Monitor Usage**
   - Set up alerts for high-volume sending
   - Review audit logs regularly
   - Investigate anomalies

## Bulk Role Assignment

### Using PowerShell

```powershell
# Connect to Dynamics 365
Connect-CrmOnline -ServerUrl https://mauriciomaster.crm.dynamics.com

# Get the security role ID
$roleId = (Get-CrmRecords -EntityLogicalName role -FilterAttribute name -FilterOperator eq -FilterValue "Customer Service Supervisor").CrmRecords[0].roleid

# Get users to assign
$users = Get-CrmRecords -EntityLogicalName systemuser -FilterAttribute isdisabled -FilterOperator eq -FilterValue $false

# Assign role to each user
foreach ($user in $users.CrmRecords) {
    Add-CrmSecurityRoleToUser -UserId $user.systemuserid -SecurityRoleId $roleId
}
```

### Using Power Automate

Create a flow to auto-assign roles based on criteria:
- Trigger: When user is created/updated
- Condition: Check if user meets criteria
- Action: Assign security role

## Summary Checklist

### For Supervisors (Senders):
- [ ] Customer Service Supervisor role assigned
- [ ] Create privilege on App Notification (Organization)
- [ ] Read privilege on System User (Organization)
- [ ] Read privilege on Queue (Organization)
- [ ] Canvas App shared with user
- [ ] Power Automate flow shared with user

### For Regular Users (Recipients):
- [ ] Basic User role assigned
- [ ] Read privilege on App Notification (User level)
- [ ] Can access D365 environment

### For Application:
- [ ] Canvas App published
- [ ] Power Automate flow active
- [ ] Connections valid and shared
- [ ] Audit logging enabled
- [ ] Security roles configured
- [ ] SiteMap integrated
