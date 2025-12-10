# Power Automate Flow Setup Guide

## Flow Name
Send Broadcast Notification

## Trigger
**Type**: PowerApps (Manual trigger)

### Input Parameters:
1. **notificationType** (Text, Required)
   - Description: "everyone, queue, or specific"
   
2. **message** (Text, Required)
   - Description: "The notification message content"
   
3. **queueId** (Text, Optional)
   - Description: "Queue GUID (optional)"
   
4. **userIds** (Text, Optional)
   - Description: "Comma-separated user GUIDs (optional)"

## Flow Structure

### Step 1: Initialize Variable - UsersList
- **Action**: Initialize variable
- **Name**: UsersList
- **Type**: Array
- **Value**: [] (empty array)

### Step 2: Switch on NotificationType
- **Action**: Switch
- **Expression**: `triggerBody()['notificationType']`

#### Case 1: "everyone"

**Action 2.1**: List All Active Users
- **Action Type**: Dataverse - List rows
- **Table**: systemusers
- **Filter**: `isdisabled eq false and accessmode eq 0`
- **Select columns**: systemuserid, fullname

**Action 2.2**: For each Active User
- **Action Type**: Apply to each
- **Input**: `outputs('List_All_Active_Users')?['body/value']`
  
  **Sub-action**: Append User to List
  - **Action Type**: Append to array variable
  - **Name**: UsersList
  - **Value**: 
    ```json
    {
      "systemuserid": "@{items('For_each_Active_User')?['systemuserid']}",
      "fullname": "@{items('For_each_Active_User')?['fullname']}"
    }
    ```

#### Case 2: "queue"

**Action 2.3**: List Queue Members
- **Action Type**: Dataverse - List rows
- **Table**: queuememberships
- **Filter**: `_queueid_value eq '@{triggerBody()['queueId']}'`
- **Select columns**: _systemuserid_value

**Action 2.4**: For each Queue Member
- **Action Type**: Apply to each
- **Input**: `outputs('List_Queue_Members')?['body/value']`
  
  **Sub-action 2.4.1**: Get Queue Member Details
  - **Action Type**: Dataverse - Get a row by ID
  - **Table**: systemusers
  - **Row ID**: `@{items('For_each_Queue_Member')?['_systemuserid_value']}`
  - **Select columns**: systemuserid, fullname, isdisabled
  
  **Sub-action 2.4.2**: Condition - User Active
  - **Condition**: `outputs('Get_Queue_Member_Details')?['body/isdisabled']` equals `false`
  
  **If Yes**:
    - Append Queue User to List
    - **Action Type**: Append to array variable
    - **Name**: UsersList
    - **Value**:
      ```json
      {
        "systemuserid": "@{outputs('Get_Queue_Member_Details')?['body/systemuserid']}",
        "fullname": "@{outputs('Get_Queue_Member_Details')?['body/fullname']}"
      }
      ```

#### Case 3: "specific"

**Action 2.5**: Split User IDs
- **Action Type**: Compose
- **Inputs**: `split(triggerBody()['userIds'], ',')`

**Action 2.6**: For each Specific User
- **Action Type**: Apply to each
- **Input**: `outputs('Split_User_IDs')`
  
  **Sub-action 2.6.1**: Get Specific User
  - **Action Type**: Dataverse - Get a row by ID
  - **Table**: systemusers
  - **Row ID**: `@{trim(items('For_each_Specific_User'))}`
  - **Select columns**: systemuserid, fullname, isdisabled
  
  **Sub-action 2.6.2**: Condition - Specific User Active
  - **Condition**: `outputs('Get_Specific_User')?['body/isdisabled']` equals `false`
  
  **If Yes**:
    - Append Specific User to List
    - **Action Type**: Append to array variable
    - **Name**: UsersList
    - **Value**:
      ```json
      {
        "systemuserid": "@{outputs('Get_Specific_User')?['body/systemuserid']}",
        "fullname": "@{outputs('Get_Specific_User')?['body/fullname']}"
      }
      ```

### Step 3: Initialize Variable - SuccessCount
- **Action**: Initialize variable
- **Name**: SuccessCount
- **Type**: Integer
- **Value**: 0

### Step 4: For each User - Send Notification
- **Action Type**: Apply to each
- **Input**: `variables('UsersList')`
- **Concurrency Control**: Enable (5 parallel operations)

  **Sub-action 4.1**: Create App Notification
  - **Action Type**: Dataverse - Add a new row
  - **Table**: appnotifications
  - **Fields**:
    - **title**: "Broadcast Notification"
    - **body**: `@{triggerBody()['message']}`
    - **ownerid@odata.bind**: `/systemusers(@{items('For_each_User_Send_Notification')?['systemuserid']})`
    - **icontype**: 100000000 (Info icon)
    - **priority**: 200000000 (Normal priority)
  
  **Sub-action 4.2**: Increment Success Counter
  - **Action Type**: Increment variable
  - **Name**: SuccessCount
  - **Value**: 1
  - **Run after**: Create App Notification succeeds

### Step 5: Respond to PowerApp
- **Action**: Response (PowerApp)
- **Status Code**: 200
- **Body**:
  ```json
  {
    "success": true,
    "message": "Notifications sent successfully",
    "userCount": "@{variables('SuccessCount')}",
    "totalUsers": "@{length(variables('UsersList'))}"
  }
  ```
- **Run after**: For each User Send Notification (Succeeded, Failed, Skipped, TimedOut)

## Connection Configuration

### Required Connection: Dataverse

1. **Connection Name**: Dataverse (mauriciomaster)
2. **Authentication Type**: OAuth
3. **Environment**: https://mauriciomaster.crm.dynamics.com

## Error Handling

The flow includes error handling:
- Failed user lookups don't stop the flow
- Only active users receive notifications
- Response includes success count vs. total users
- Flow responds even if some notifications fail

## Testing

### Test Case 1: Everyone
**Input**:
```json
{
  "notificationType": "everyone",
  "message": "Test notification to all users"
}
```

### Test Case 2: Queue
**Input**:
```json
{
  "notificationType": "queue",
  "message": "Test notification to queue members",
  "queueId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### Test Case 3: Specific Users
**Input**:
```json
{
  "notificationType": "specific",
  "message": "Test notification to specific users",
  "userIds": "userid1-guid,userid2-guid,userid3-guid"
}
```

## Performance Optimization

- Concurrency: 5 parallel notification creations
- Filtered queries to reduce data retrieval
- Only active users are processed
- Efficient error handling

## Security

- Flow uses the caller's security context
- Users must have:
  - Read access to systemusers
  - Read access to queues and queuememberships
  - Create access to appnotifications
- No admin privileges required

## Maintenance

### To modify notification appearance:
Edit these fields in the "Create App Notification" action:
- **icontype**: Change icon (100000000 = Info, 100000001 = Success, 100000002 = Failure, 100000003 = Warning, 100000004 = Mention)
- **priority**: Change priority (200000000 = Normal, 200000001 = High)

### To add expiration:
Add field in "Create App Notification":
- **expirydatetime**: Set expiration date/time

### To add custom data:
Add field in "Create App Notification":
- **data**: JSON string with custom data
