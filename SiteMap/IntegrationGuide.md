# SiteMap Integration Guide

## Adding Broadcast Notifications to Customer Service Workspace

### Method 1: Using Power Apps Site Map Designer (Recommended)

1. **Open Customer Service Workspace App**
   - Navigate to https://make.powerapps.com
   - Select your environment (mauriciomaster.crm.dynamics.com)
   - Go to **Apps**
   - Find "Customer Service workspace" app
   - Click the three dots (...) and select **Edit**

2. **Edit the Site Map**
   - In the App Designer, click **Site Map** in the left navigation
   - This opens the Site Map Designer

3. **Add a New Group (Optional)**
   - If you want a new group: Click **Add** → **Group**
   - Set **Title**: "Communications" or use existing group
   - Set **ID**: "BroadcastNotificationsGroup"

4. **Add Subarea for Broadcast Notifications**
   - Select the Group where you want to add the item
   - Click **Add** → **Subarea**
   - Configure the following properties:

   **General Tab**:
   - **Type**: URL
   - **URL**: Get your Canvas App web link (see instructions below)
   - **Title**: "Broadcast Notifications"
   - **Icon**: Use web resource or select icon
     - Recommended: Select notification/announcement icon

   **Advanced Tab**:
   - **ID**: "BroadcastNotifications"
   - **SKU**: All
   - **Client**: All
   - **Outlook**: Uncheck (not needed for this app)

5. **Set Privileges**
   - In the Subarea properties, go to **Privileges** section
   - Add privilege: Entity = "App Notification", Privilege = "Create"
   - Add privilege: Entity = "System User", Privilege = "Read"

6. **Save and Publish**
   - Click **Save**
   - Click **Publish**
   - Close the App Designer

### Method 2: Manual XML Edit

If you need to manually edit the sitemap XML:

1. **Export the Solution**
   - Go to **Settings** → **Solutions**
   - Find the solution containing Customer Service Workspace
   - Click **Export**
   - Extract the ZIP file

2. **Edit SiteMap XML**
   - Find the SiteMap file (usually in CustomizationsSiteMap folder)
   - Add the following XML inside an appropriate `<Area>` element:

```xml
<Group Id="BroadcastNotificationsGroup" ResourceId="Group.BroadcastNotificationsGroup.Title">
  <SubArea Id="BroadcastNotifications" 
           ResourceId="SubArea.BroadcastNotifications.Title"
           Icon="/_imgs/area/Announcements_16.png"
           Url="/main.aspx?appid=YOUR_CANVAS_APP_ID_HERE"
           Client="All"
           AvailableOffline="false"
           PassParams="false">
    <Privilege Entity="appnotification" Privilege="Create" />
    <Privilege Entity="systemuser" Privilege="Read" />
  </SubArea>
</Group>
```

3. **Add Localization Strings**
   - Edit the resources file to add:
   ```xml
   <LocalizedLabel Id="Group.BroadcastNotificationsGroup.Title" languagecode="1033">
     <Label>Communications</Label>
   </LocalizedLabel>
   <LocalizedLabel Id="SubArea.BroadcastNotifications.Title" languagecode="1033">
     <Label>Broadcast Notifications</Label>
   </LocalizedLabel>
   ```

4. **Repackage and Import**
   - Zip the solution folder
   - Import back into D365

### Method 3: Create Custom App with Embedded Canvas App

1. **Create Model-Driven App**
   - Go to https://make.powerapps.com
   - Click **Create** → **Model-driven app**
   - Use modern app designer

2. **Add Canvas App as Component**
   - In the app designer, add a new **Page**
   - Choose **Canvas app**
   - Select your Broadcast Notification Canvas app
   - Set title and icon

3. **Publish the App**
   - Save and publish
   - Share with Customer Service users

## Getting Your Canvas App URL

### Option A: Get Web Link from Power Apps

1. Go to https://make.powerapps.com
2. Select **Apps**
3. Find "Broadcast Notification App"
4. Click the three dots (...) → **Details**
5. Copy the **Web link**
6. The link will look like:
   ```
   https://apps.powerapps.com/play/e/[environment-id]/a/[app-id]?tenantId=[tenant-id]
   ```

### Option B: Use App ID Format

If you have the App ID, format it as:
```
/main.aspx?appid=[your-canvas-app-id]
```

Replace `[your-canvas-app-id]` with your actual Canvas App GUID.

## Icon Options

### Built-in Icons (Recommended)
Use these web resource paths for icons:

- **Announcements**: `/_imgs/area/Announcements_16.png`
- **Notifications**: `/$webresource/msdyn_/imgs/notificationicon.svg`
- **Chat**: `/_imgs/ribbon/Chat_16.png`
- **Email**: `/_imgs/area/email_24.png`
- **Broadcast**: `/_imgs/ribbon/Broadcast_16.png`

### Custom Icon
1. Create a 16x16 or 32x32 PNG/SVG icon
2. Upload as web resource
3. Reference in Icon property: `$webresource:new_youricon`

## Security Configuration

### Grant Access to Security Roles

1. **Navigate to Security Roles**
   - Go to **Settings** → **Security** → **Security Roles**
   - Find "Customer Service Supervisor" role
   - Click to edit

2. **Set Entity Permissions**

   **Core Records Tab**:
   - **App Notification**: 
     - Create: Organization level (green circle)
     - Read: Organization level (green circle)
     - Write: Organization level (green circle)
   
   **Custom Entities Tab** (if needed):
   - **Queue**: Read at minimum User level
   - **Queue Membership**: Read at minimum User level

3. **Business Management Tab**:
   - **User**: Read access (at least User level)

4. **Save and Close**

### For Regular Users (Recipients)
Regular users only need:
- **App Notification**: Read access (User level is sufficient)

## Testing the Integration

1. **Clear Browser Cache**
   - Press Ctrl+Shift+Delete
   - Clear cached images and files

2. **Sign Out and Sign In**
   - Sign out of D365
   - Close all browser tabs
   - Sign back in

3. **Open Customer Service Workspace**
   - Look for "Broadcast Notifications" in the menu
   - Click to open
   - Verify the Canvas App loads

4. **Test Functionality**
   - Try sending a test notification
   - Check if notifications appear for recipients

## Troubleshooting

### Issue: Menu item doesn't appear
**Solutions**:
- Clear browser cache
- Check security role has access to subarea
- Verify sitemap was published
- Check if user has required privileges

### Issue: Canvas App doesn't load
**Solutions**:
- Verify Canvas App is published
- Check Canvas App URL is correct
- Ensure user has access to Canvas App
- Check if Dataverse connection is working

### Issue: "Access Denied" error
**Solutions**:
- Verify user has Create privilege on App Notification entity
- Check user has Read privilege on System User entity
- Ensure Canvas App is shared with the user

### Issue: Menu item shows but app not found
**Solutions**:
- Verify the App ID in the URL is correct
- Check Canvas App still exists and wasn't deleted
- Ensure environment URL is correct

## Alternative Integration Points

### 1. Dashboard Component
Add Canvas App as a component in a dashboard:
- Create new dashboard
- Add Canvas App component
- Pin to workspace

### 2. Form Component
Embed in a form:
- Edit a commonly used form
- Add Canvas App control
- Configure to show in specific tab

### 3. Quick Create
Add to quick create menu (not recommended for this use case)

### 4. Command Bar Button
Add custom button to command bar:
- Uses ribbon customization
- More complex but accessible from anywhere

## Best Practices

1. **Icon Selection**: Choose clear, recognizable icons
2. **Placement**: Add to a logical group (Communications, Tools, etc.)
3. **Naming**: Use clear, descriptive names
4. **Privileges**: Set minimum required privileges
5. **Testing**: Test with actual user accounts, not admin
6. **Documentation**: Document location for user training

## User Training

After integration, inform users:
- Location of the new menu item
- Purpose of the broadcast notification feature
- How to send notifications
- Best practices for messaging

Create a quick reference guide or video tutorial.
