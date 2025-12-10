# Canvas App Design Specifications

## App Information
- **Name**: Broadcast Notification App
- **Type**: Canvas App (Tablet Layout)
- **Orientation**: Landscape
- **Size**: 1366 x 768

## Color Scheme
- **Primary**: #0078D4 (Microsoft Blue)
- **Secondary**: #106EBE (Darker Blue)
- **Success**: #107C10 (Green)
- **Error**: #D13438 (Red)
- **Warning**: #FF8C00 (Orange)
- **Background**: #F3F2F1 (Light Gray)
- **Text Primary**: #323130 (Dark Gray)
- **Text Secondary**: #605E5C (Medium Gray)

## Screen Layout

### Header Section (0, 0, 1366, 80)
```
┌────────────────────────────────────────────────────────────┐
│  📢 Send Broadcast Notification                            │
│  Communicate with your team instantly                      │
└────────────────────────────────────────────────────────────┘
```

**Components**:
- `imgIcon`: Icon (0, 20, 40, 40)
  - Image: notification bell icon
- `lblTitle`: Label (50, 15, 600, 35)
  - Text: "Send Broadcast Notification"
  - Font: Segoe UI Semibold, 24pt
  - Color: #323130
- `lblSubtitle`: Label (50, 45, 600, 25)
  - Text: "Communicate with your team instantly"
  - Font: Segoe UI, 14pt
  - Color: #605E5C

### Main Content Section (0, 80, 1366, 608)

#### Left Panel - Form (40, 100, 650, 588)

**Notification Type Section (40, 100, 650, 120)**
```
Notification Type:
[Everyone                    ▼]
```
- `lblNotifType`: Label (40, 100, 250, 32)
  - Text: "Notification Type:"
  - Font: Segoe UI Semibold, 16pt
- `drpNotificationType`: Dropdown (40, 135, 300, 45)
  - ChevronBackground: #FFFFFF
  - ChevronFill: #0078D4
  - BorderColor: #8A8886
  - BorderThickness: 1

**Queue Section (40, 230, 650, 100)** [Conditional]
```
Select Queue:
[Customer Support Queue      ▼]
```
- `lblQueue`: Label (40, 230, 250, 32)
  - Text: "Select Queue:"
  - Font: Segoe UI Semibold, 16pt
  - Visible: drpNotificationType = "Specific Queue"
- `cmbQueue`: ComboBox (40, 265, 400, 45)
  - Visible: drpNotificationType = "Specific Queue"

**Users Section (40, 230, 650, 100)** [Conditional]
```
Select Users: (3 selected)
[John Doe, Jane Smith, Bob...]
```
- `lblUsers`: Label (40, 230, 250, 32)
  - Text: "Select Users:"
  - Font: Segoe UI Semibold, 16pt
  - Visible: drpNotificationType = "Specific Users"
- `cmbUsers`: ComboBox (40, 265, 400, 45)
  - Visible: drpNotificationType = "Specific Users"
  - SelectMultiple: true
- `lblUserCount`: Label (450, 265, 180, 45)
  - Text: CountRows(cmbUsers.SelectedItems) & " selected"
  - Color: #0078D4
  - Visible: drpNotificationType = "Specific Users"

**Message Section (40, 350, 650, 280)**
```
Message: *
┌────────────────────────────────────────────┐
│                                            │
│  [Type your message here...]               │
│                                            │
│                                            │
│                                            │
└────────────────────────────────────────────┘
128 / 500 characters
```
- `lblMessage`: Label (40, 350, 250, 32)
  - Text: "Message: *"
  - Font: Segoe UI Semibold, 16pt
- `txtMessage`: Text Input (40, 385, 650, 180)
  - Mode: MultiLine
  - BorderColor: #8A8886
  - BorderThickness: 1
  - Font: Segoe UI, 14pt
  - PaddingTop: 10
  - PaddingLeft: 10
- `lblCharCount`: Label (40, 570, 650, 25)
  - Font: Segoe UI, 12pt
  - Dynamic color based on length

**Action Buttons (40, 610, 650, 50)**
```
[Send Notification]  [Clear]
```
- `btnSend`: Button (40, 610, 200, 50)
  - Text: "Send Notification"
  - Fill: #0078D4
  - HoverFill: #106EBE
  - Color: #FFFFFF
  - Font: Segoe UI Semibold, 16pt
  - BorderRadius: 4
- `btnClear`: Button (260, 610, 120, 50)
  - Text: "Clear"
  - Fill: #FFFFFF
  - HoverFill: #F3F2F1
  - Color: #323130
  - BorderColor: #8A8886
  - BorderThickness: 1
  - Font: Segoe UI, 16pt
  - BorderRadius: 4

#### Right Panel - Info & Preview (730, 100, 600, 588)

**Info Card (730, 100, 580, 250)**
```
┌─────────────────────────────────────────────┐
│ 💡 Tips for Effective Notifications         │
│                                             │
│ • Keep messages clear and concise           │
│ • Include actionable information            │
│ • Use appropriate notification type         │
│ • Avoid sending too frequently              │
│                                             │
│ Recipients will see notifications in their  │
│ notification center immediately.            │
└─────────────────────────────────────────────┘
```
- `rectInfoCard`: Rectangle (730, 100, 580, 250)
  - Fill: #FFFFFF
  - BorderColor: #E1DFDD
  - BorderThickness: 1
  - BorderRadius: 4
- `lblInfoTitle`: Label (750, 120, 540, 35)
  - Text: "💡 Tips for Effective Notifications"
  - Font: Segoe UI Semibold, 16pt
- `lblInfoContent`: Label (750, 160, 540, 170)
  - Text: [Tips content]
  - Font: Segoe UI, 14pt
  - Color: #605E5C

**Preview Card (730, 370, 580, 220)**
```
┌─────────────────────────────────────────────┐
│ Preview                                     │
│                                             │
│ 🔔 Broadcast Notification                   │
│                                             │
│ [Your message will appear here...]          │
│                                             │
│ Sent by: [Your Name]                        │
└─────────────────────────────────────────────┘
```
- `rectPreviewCard`: Rectangle (730, 370, 580, 220)
  - Fill: #F8F8F8
  - BorderColor: #E1DFDD
  - BorderThickness: 1
  - BorderRadius: 4
- `lblPreviewTitle`: Label (750, 385, 540, 30)
  - Text: "Preview"
  - Font: Segoe UI Semibold, 14pt
- `rectNotifPreview`: Rectangle (750, 420, 540, 140)
  - Fill: #FFFFFF
  - BorderColor: #0078D4
  - BorderThickness: 2
  - BorderRadius: 2
- `lblNotifIcon`: Label (765, 430, 40, 40)
  - Text: "🔔"
  - Size: 24pt
- `lblNotifTitle`: Label (810, 435, 460, 30)
  - Text: "Broadcast Notification"
  - Font: Segoe UI Semibold, 14pt
- `lblNotifBody`: Label (810, 470, 460, 60)
  - Text: txtMessage.Text (or placeholder)
  - Font: Segoe UI, 12pt
  - Color: #323130
- `lblNotifSender`: Label (810, 535, 460, 20)
  - Text: "Sent by: " & User().FullName
  - Font: Segoe UI, 10pt
  - Color: #605E5C

### Footer Section (0, 688, 1366, 80)

**Status Bar (40, 700, 1286, 50)**
```
[Loading Spinner] Sending notifications, please wait...
```
- `rectStatus`: Rectangle (40, 700, 1286, 50)
  - Fill: #FFF4CE
  - Visible: varIsLoading
  - BorderRadius: 4
- `imgSpinner`: Image (50, 710, 30, 30)
  - Image: Loading spinner GIF
  - Visible: varIsLoading
- `lblStatus`: Label (90, 710, 1200, 30)
  - Text: "Sending notifications, please wait..."
  - Font: Segoe UI, 14pt
  - Visible: varIsLoading

**Success Message**
- `rectSuccess`: Rectangle (40, 700, 1286, 50)
  - Fill: #DFF6DD
  - Visible: varNotificationSent
  - BorderColor: #107C10
  - BorderThickness: 1
- `lblSuccess`: Label (50, 710, 1200, 30)
  - Text: "✓ Notification sent successfully"
  - Color: #107C10
  - Font: Segoe UI Semibold, 14pt
  - Visible: varNotificationSent

## Responsive Behavior

### Mobile Considerations
If creating a mobile version:
- Stack panels vertically
- Full width form elements
- Larger touch targets (min 44x44 pt)
- Hide preview panel
- Simplified layout

## Accessibility

- **Tab Order**: Set logical tab order through form
- **Alt Text**: Add descriptive alt text to all controls
- **Color Contrast**: Minimum 4.5:1 ratio for text
- **Screen Reader**: Label associations for form controls
- **Keyboard Navigation**: Support Enter key for submit

## Animation & Interactions

- **Button Hover**: Subtle color change
- **Focus State**: Blue outline on focused elements
- **Loading State**: Spinner animation during send
- **Success State**: Brief green flash on success
- **Error Shake**: Subtle shake on validation error

## Data Connections Required

1. **Dataverse**
   - Queues (queues)
   - Users (systemusers)

2. **Power Automate**
   - SendBroadcastNotification flow

## Variables Used

- `varNotifType`: Text - Current notification type
- `varQueueId`: Text - Selected queue ID
- `varUserIds`: Text - Comma-separated user IDs
- `varResponse`: Record - Flow response
- `varIsLoading`: Boolean - Loading state
- `varNotificationSent`: Boolean - Success state
