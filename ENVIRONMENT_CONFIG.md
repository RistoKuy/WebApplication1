# Environment Configuration Guide

This guide explains how the application has been refactored to use environment variables for configuration management.

## Overview

The application has been refactored to separate configuration from code using:
- `.env` file for environment variables
- `EnvConfig.java` utility class for reading configuration
- `DatabaseUtil.java` for database connections
- Updated JSP files to use configuration utilities

## Environment Variables

### Database Configuration
- `DB_URL`: Database connection URL
- `DB_USERNAME`: Database username
- `DB_PASSWORD`: Database password
- `DB_DRIVER`: JDBC driver class name

### Firebase Configuration
- `FIREBASE_API_KEY`: Firebase Web API key
- `FIREBASE_AUTH_DOMAIN`: Firebase Auth domain
- `FIREBASE_PROJECT_ID`: Firebase project ID
- `FIREBASE_STORAGE_BUCKET`: Firebase storage bucket
- `FIREBASE_MESSAGING_SENDER_ID`: Firebase messaging sender ID
- `FIREBASE_APP_ID`: Firebase app ID
- `FIREBASE_MEASUREMENT_ID`: Firebase Analytics measurement ID
- `FIREBASE_DATABASE_URL`: Firebase Realtime Database URL
- `FIREBASE_SERVICE_ACCOUNT_PATH`: Path to Firebase service account JSON file

### Application Configuration
- `APP_UPLOAD_DIR`: Directory for file uploads
- `APP_SESSION_TIMEOUT`: Session timeout in minutes
- `PASSWORD_MIN_LENGTH`: Minimum password length
- `SESSION_SECURE`: Whether to use secure sessions

## Setup Instructions

### 1. Copy Environment File
```bash
copy .env.example .env
```

### 2. Update Configuration
Edit `.env` file with your actual values:

```env
# Database Configuration
DB_URL=jdbc:mysql://localhost:3306/web_enterprise
DB_USERNAME=root
DB_PASSWORD=your_database_password

# Firebase Configuration
FIREBASE_API_KEY=your_actual_api_key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
# ... etc
```

### 3. Firebase Service Account
1. Download your Firebase service account JSON from Firebase Console
2. Place it in `web/WEB-INF/firebase-adminsdk.json`
3. Update `FIREBASE_SERVICE_ACCOUNT_PATH` if needed

## Code Changes Made

### 1. New Utility Classes
- `src/java/util/EnvConfig.java`: Environment configuration reader
- `src/java/util/DatabaseUtil.java`: Database connection utility

### 2. Updated JSP Files
The following files were updated to use environment configuration:

**Firebase Configuration:**
- `web/firebase_config.jsp`: Uses EnvConfig for Firebase settings
- `web/change_password.jsp`: Uses EnvConfig for Firebase initialization
- `web/login.jsp`: Uses firebase_config.jsp (which uses EnvConfig), documented for additional UI configuration

**Database Configuration:**
- `web/account_list.jsp`
- `web/checkout.jsp`
- `web/login_output.jsp`
- `web/update_profile.jsp`
- `web/user_order_detail.jsp`
- `web/user_order_actions.jsp`
- `web/user_orders.jsp`
- `web/admin_orders.jsp`
- `web/admin_order_detail.jsp`
- `web/admin_order_actions.jsp`
- `web/admin_add_item.jsp`
- `web/admin_delete_item.jsp`
- `web/admin_add_user.jsp`
- `web/admin_delete_user.jsp`
- `web/admin_update_role.jsp`
- `web/admin_update_user.jsp`
- `web/admin_update_item.jsp`

### 3. Database Connection Pattern
**Before:**
```java
Class.forName("com.mysql.cj.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/web_enterprise";
String dbUser = "root";
String dbPassword = "";
conn = DriverManager.getConnection(url, dbUser, dbPassword);
```

**After:**
```java
conn = util.DatabaseUtil.getConnection();
```

### 4. Firebase Configuration Pattern
**Before:**
```javascript
const firebaseConfig = {
    apiKey: "AIzaSyCfYaFJQsmu4Qt4YthfsCYpkAE6iyyGhBg",
    authDomain: "webapplication1-4bebd.firebaseapp.com",
    // ... hardcoded values
};
```

**After:**
```jsp
const firebaseConfig = {
    apiKey: "<%= EnvConfig.getFirebaseApiKey() %>",
    authDomain: "<%= EnvConfig.getFirebaseAuthDomain() %>",
    // ... using environment variables
};
```

## Security Benefits

1. **Credentials Separation**: Database passwords and API keys are no longer in source code
2. **Environment-Specific Configuration**: Different settings for development/production
3. **Version Control Safety**: `.env` file is gitignored to prevent credential exposure
4. **Centralized Configuration**: All configuration in one place

## Development vs Production

### Development
- Use `.env` file for local configuration
- Keep Firebase service account file locally

### Production
- Set environment variables in your deployment platform
- Ensure Firebase service account file is securely deployed
- Use strong database passwords and secure connections

## Migration Notes

### If Updating Existing Installation:
1. Create `.env` file with current settings
2. Recompile Java classes (EnvConfig and DatabaseUtil)
3. Restart application server
4. Verify all functionality works

### Configuration Validation:
- Check database connectivity: Access any page that uses database
- Check Firebase configuration: Try login/registration
- Monitor application logs for configuration errors

## Troubleshooting

### Common Issues:

1. **ClassNotFoundException**: Ensure `util.EnvConfig` is compiled and in classpath
2. **Database Connection Failed**: Verify `.env` database settings
3. **Firebase Errors**: Check Firebase configuration values in `.env`
4. **File Not Found**: Ensure Firebase service account file path is correct

### Debug Information:
- `DatabaseUtil.getConnectionInfo()` returns database connection details (without password)
- Check server logs for configuration loading messages
- Verify `.env` file is in project root directory

## Example .env File

See `.env.example` for a complete template with all required variables.

## Security Reminders

- ❌ Never commit `.env` file to version control
- ❌ Never commit Firebase service account JSON to version control  
- ✅ Use strong passwords and secure connections in production
- ✅ Regularly rotate API keys and credentials
- ✅ Use HTTPS in production environments
