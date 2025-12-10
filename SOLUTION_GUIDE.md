# Broadcast Notification System for Dynamics 365 Customer Service

A complete solution that enables Customer Service Supervisors to send broadcast notifications to D365 users directly from the Customer Service Workspace.

## Features

- **Multiple Notification Modes:**
  - Notify all active users
  - Notify users in a specific queue
  - Notify specific selected users

- **User-Friendly Interface:**
  - Simple text input for messages
  - Dropdown selection for notification type
  - Dynamic UI that shows relevant options based on selection
  - Character counter (500 character limit)

- **Integration:**
  - Accessible from Customer Service Workspace menu
  - Uses D365 in-app notifications
  - Built as a managed solution for easy deployment

## Prerequisites

- Dynamics 365 Customer Service environment
- Power Apps and Power Automate licenses
- System Administrator or System Customizer security role for installation
- Customer Service Representative or higher role for users

## Installation Instructions

### Option 1: Import Solution (Recommended)

1. **Download the solution file** (once packaged)
2. Navigate to Power Apps (https://make.powerapps.com)
3. Select your environment (mauriciomaster.crm.dynamics.com)
4. Go to **Solutions** > **Import solution**
5. Browse and select the solution ZIP file
6. Click **Next** > **Import**
7. Wait for import to complete

### Option 2: Manual Setup

Since Canvas Apps require manual creation in Power Apps Studio, follow these steps:

#### Step 1: Create the Power Automate Flow

1. Go to https://make.powerautomate.com
2. Select your environment
3. Click **Create** > **Instant cloud flow**
4. Name it: "Send Broadcast Notification"
5. Choose trigger: **PowerApps**
6. Add inputs:
   - `notificationType` (Text)
   - `message` (Text)
   - `queueId` (Text)
   - `userIds` (Text)

7. Add actions as defined in the flow diagram below:

```
Trigger: PowerApps
│
├─ Initialize variable: UsersList (Array)
│
├─ Switch: notificationType
│  │
│  ├─ Case "everyone"
│  │  ├─ List records: systemusers (filter: isdisabled eq false)
│  │  └─ Append to UsersList
│  │
│  ├─ Case "queue"
│  │  ├─ List records: queuememberships (filter: _queueid_value eq queueId)
│  │  └─ Append to UsersList
│  │
│  └─ Case "specific"
│     ├─ Split userIds by comma
│     └─ For each userId
│        ├─ Get systemuser record
│        └─ Append to UsersList
│
├─ Apply to each user in UsersList
│  └─ Create record: appnotifications
│     ├─ title: "Broadcast Notification"
│     ├─ body: message
│     ├─ ownerid: user systemuserid
│     ├─ icontype: 100000000
│     └─ priority: 200000000
│
└─ Response: Success message with user count
```

8. **Save** the flow

#### Step 2: Create the Canvas App

1. Go to https://make.powerapps.com
2. Click **Create** > **Canvas app from blank**
3. Name it: "Broadcast Notification App"
4. Format: Tablet
5. Add a Dataverse connection

**Screen Layout:**

```
┌─────────────────────────────────────────────┐
│  Send Broadcast Notification                │
├─────────────────────────────────────────────┤
│                                             │
│  Notification Type:                         │
│  [Dropdown: Everyone ▼]                     │
│                                             │
│  [Queue Selector - shown if "Queue"]        │
│  [User Selector - shown if "Specific"]      │
│                                             │
│  Message:                                   │
│  ┌─────────────────────────────────────┐   │
│  │                                     │   │
│  │  [Text input area]                  │   │
│  │                                     │   │
│  │                                     │   │
│  └─────────────────────────────────────┘   │
│  0 / 500 characters                         │
│                                             │
│  [Send Notification]  [Clear]               │
│                                             │
└─────────────────────────────────────────────┘
```

**Controls to Add:**

1. **Label** (Title)
   - Text: "Send Broadcast Notification"
   - Font: Bold, Size 20

2. **Label** (Notification Type Label)
   - Text: "Notification Type:"

3. **Dropdown** (drpNotificationType)
   - Items: `["Everyone", "Specific Queue", "Specific Users"]`
   - Default: "Everyone"

4. **ComboBox** (cmbQueue)
   - Items: `Filter(Queues, statecode = 0)`
   - DisplayFields: `["name"]`
   - Visible: `drpNotificationType.Selected.Value = "Specific Queue"`

5. **ComboBox** (cmbUsers)
   - Items: `Filter(Users, isdisabled = false)`
   - DisplayFields: `["fullname"]`
   - SelectMultiple: true
   - Visible: `drpNotificationType.Selected.Value = "Specific Users"`

6. **Label** (Message Label)
   - Text: "Message:"

7. **Text Input** (txtMessage)
   - Mode: MultiLine
   - HintText: "Enter your broadcast message here..."
   - MaxLength: 500
   - Height: 200

8. **Label** (Character Counter)
   - Text: `Len(txtMessage.Text) & " / 500 characters"`

9. **Button** (btnSend)
   - Text: "Send Notification"
   - OnSelect: See formula below

10. **Button** (btnClear)
    - Text: "Clear"
    - OnSelect: `Reset(txtMessage); Reset(drpNotificationType); Reset(cmbQueue); Reset(cmbUsers)`

**Button OnSelect Formula (btnSend):**

```powerFx
If(
    IsBlank(txtMessage.Text),
    Notify("Please enter a message", NotificationType.Error),
    
    // Determine notification type
    Set(varNotifType, 
        If(drpNotificationType.Selected.Value = "Everyone", "everyone",
        If(drpNotificationType.Selected.Value = "Specific Queue", "queue",
        "specific"))
    );
    
    // Get queue ID if needed
    Set(varQueueId, 
        If(drpNotificationType.Selected.Value = "Specific Queue", 
            Text(cmbQueue.Selected.queueid), 
            "")
    );
    
    // Get user IDs if needed
    Set(varUserIds,
        If(drpNotificationType.Selected.Value = "Specific Users",
            Concat(cmbUsers.SelectedItems, systemuserid, ","),
            "")
    );
    
    // Call the flow
    Set(varResponse, 
        SendBroadcastNotification.Run(
            varNotifType,
            txtMessage.Text,
            varQueueId,
            varUserIds
        )
    );
    
    // Show result
    If(varResponse.success,
        Notify("Notification sent to " & varResponse.userCount & " user(s)", NotificationType.Success);
        Reset(txtMessage); 
        Reset(drpNotificationType); 
        Reset(cmbQueue); 
        Reset(cmbUsers),
        
        Notify("Failed to send notifications", NotificationType.Error)
    )
)
```

**Add Data Sources:**
- Dataverse > Tables > Queues
- Dataverse > Tables > Users (systemusers)
- Power Automate > SendBroadcastNotification

11. **Save and Publish** the app

#### Step 3: Add to Customer Service Workspace

1. Go to Power Apps > Solutions > Default Solution
2. Click **New** > **App** > **Model-driven app**
3. Name: "Customer Service Workspace Extensions"
4. Click **Advanced settings**
5. Add a new **Area** or use existing
6. Add a **Group** named "Notifications"
7. Add a **Subarea**:
   - Title: "Broadcast Notifications"
   - Type: URL
   - URL: Get your Canvas App's web link
   - Icon: Choose notification icon

Alternatively, add to existing Customer Service Workspace sitemap:

1. Go to **App Designer** for Customer Service Workspace
2. Open **Site Map**
3. Add new **Subarea** under appropriate area
4. Set Type to **URL** and paste Canvas App link

## Configuration

### Security Roles

Assign the following privileges to the **Customer Service Supervisor** role:

- **appnotification** entity: Create privilege
- **systemuser** entity: Read privilege
- **queue** entity: Read privilege
- **queuemembership** entity: Read privilege

### Environment Variables (if needed)

None required for basic operation.

## Usage

1. Navigate to **Customer Service Workspace**
2. Click **Broadcast Notifications** from the menu
3. Select notification type:
   - **Everyone**: Sends to all active users
   - **Specific Queue**: Choose a queue from dropdown
   - **Specific Users**: Select one or more users
4. Type your message (max 500 characters)
5. Click **Send Notification**
6. Recipients will see the notification in their notification center

## Architecture

### Components

1. **Canvas App**: User interface for composing notifications
2. **Power Automate Flow**: Backend logic for retrieving users and sending notifications
3. **Dataverse Entities Used**:
   - `appnotification`: D365 in-app notifications
   - `systemuser`: User records
   - `queue`: Service queues
   - `queuemembership`: Queue member relationships

### Security

- Uses Dataverse connection with user's context
- Respects existing D365 security roles
- Only users with Create privilege on appnotification can send

## Troubleshooting

### Issue: "Permission denied"
**Solution**: Ensure user has Create privilege on appnotification entity

### Issue: Flow fails
**Solution**: 
- Check Dataverse connection in flow
- Verify flow is turned on
- Check flow run history for errors

### Issue: Notifications not appearing
**Solution**:
- Ensure recipients have notifications enabled in D365
- Check that appnotification records are being created
- Verify ownerid is set correctly

### Issue: Queue selector is empty
**Solution**: Ensure queues exist and user has Read access to queue entity

## Customization

### Change Message Length Limit
Edit `MaxLength` property of txtMessage control in Canvas App

### Add Rich Text
Replace TextInput with Rich Text Editor control

### Add Scheduling
Add date/time picker and modify flow to use "Delay until" action

### Add Templates
Create a ComboBox with pre-defined message templates

## Support

For issues or questions, contact your D365 administrator or open an issue in this repository.

## Version History

- **1.0.0.0** (Initial Release)
  - Basic broadcast notification functionality
  - Three notification modes
  - Customer Service Workspace integration

## License

This solution is provided as-is for use in your Dynamics 365 environment.
