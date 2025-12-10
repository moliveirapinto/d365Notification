#!/bin/bash

# Broadcast Notification System - Deployment Script
# This script helps set up the Power Automate flow using Microsoft Graph API

echo "=================================="
echo "D365 Broadcast Notification Setup"
echo "=================================="
echo ""

# Environment Configuration
TENANT_ID="your-tenant-id-here"
CLIENT_ID="your-client-id-here"
CLIENT_SECRET="your-client-secret-here"
ENVIRONMENT_URL="https://yourorg.crm.dynamics.com"

echo "Environment: $ENVIRONMENT_URL"
echo "Tenant ID: $TENANT_ID"
echo "Client ID: $CLIENT_ID"
echo ""

# Get Access Token
echo "Step 1: Authenticating..."
TOKEN_RESPONSE=$(curl -s -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "scope=https://service.powerapps.com/.default" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials")

ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ Authentication failed!"
    echo "Response: $TOKEN_RESPONSE"
    exit 1
fi

echo "✓ Authentication successful"
echo ""

# Instructions for manual setup
echo "========================================"
echo "Manual Setup Required"
echo "========================================"
echo ""
echo "Due to Power Platform limitations, please complete the setup manually:"
echo ""
echo "1. CREATE POWER AUTOMATE FLOW"
echo "   - Go to: https://make.powerautomate.com"
echo "   - Environment: mauriciomaster.crm.dynamics.com"
echo "   - Create instant cloud flow: 'Send Broadcast Notification'"
echo "   - Trigger: PowerApps"
echo "   - See PowerAutomate/SendBroadcastNotification.json for flow definition"
echo ""
echo "2. CREATE CANVAS APP"
echo "   - Go to: https://make.powerapps.com"
echo "   - Create Canvas app from blank: 'Broadcast Notification App'"
echo "   - See CanvasApp/BroadcastNotificationApp.msapp for app design"
echo "   - Connect to the Power Automate flow"
echo ""
echo "3. CONFIGURE SECURITY"
echo "   - Go to: https://mauriciomaster.crm.dynamics.com"
echo "   - Settings > Security > Security Roles"
echo "   - Edit 'Customer Service Supervisor' role"
echo "   - Grant 'Create' privilege on 'App Notification' entity"
echo ""
echo "4. ADD TO CUSTOMER SERVICE WORKSPACE"
echo "   - Open Customer Service Workspace app in App Designer"
echo "   - Edit Site Map"
echo "   - Add new subarea with Canvas App URL"
echo ""
echo "See SOLUTION_GUIDE.md for detailed step-by-step instructions"
echo ""
echo "========================================"
echo "Useful Links"
echo "========================================"
echo "Power Automate: https://make.powerautomate.com"
echo "Power Apps: https://make.powerapps.com"
echo "D365 Environment: $ENVIRONMENT_URL"
echo "Solutions: https://make.powerapps.com/environments/[ENV_ID]/solutions"
echo ""
echo "Press Enter to continue..."
read

# Open browser to Power Automate
echo "Opening Power Automate in browser..."
"$BROWSER" "https://make.powerautomate.com" 2>/dev/null || xdg-open "https://make.powerautomate.com" 2>/dev/null || open "https://make.powerautomate.com" 2>/dev/null

echo ""
echo "✓ Setup guide displayed"
echo "Follow the instructions above to complete the installation"
