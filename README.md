# WebApplication1 - JSP Enterprise Web Application

A modern JSP-based web application with Firebase authentication, user management, and e-commerce functionality.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Setup & Installation](#setup--installation)
- [Firebase Configuration](#firebase-configuration)
- [Build & Deployment](#build--deployment)
- [Usage Guide](#usage-guide)
- [API Documentation](#api-documentation)
- [Security Features](#security-features)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🌟 Overview

WebApplication1 is a full-featured enterprise web application built with JSP, Firebase, and MySQL. It provides authentication, user management, shopping cart functionality, and admin controls with a modern, responsive UI.

### Tech Stack
- **Backend**: JSP, Java Servlets
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5
- **Authentication**: Firebase Auth
- **Database**: Firebase Realtime Database + MySQL
- **Server**: Apache Tomcat
- **Build Tool**: Apache Ant

## ✨ Features

### Authentication & User Management
- ✅ Firebase Authentication integration
- ✅ User registration and login
- ✅ Password change functionality
- ✅ Session management
- ✅ Admin and user role separation

### E-commerce Features
- ✅ Product catalog
- ✅ Shopping cart functionality
- ✅ Item management (admin)
- ✅ User account management

### Security Features
- ✅ Client-side re-authentication
- ✅ Server-side validation
- ✅ Password strength requirements
- ✅ Secure Firebase Admin SDK integration
- ✅ Session-based access control

### UI/UX
- ✅ Modern dark theme design
- ✅ Responsive Bootstrap layout
- ✅ Interactive animations
- ✅ User-friendly forms

## 📁 Project Structure

```
WebApplication1/
├── build/                      # Compiled output
├── web/                        # Web application root
│   ├── *.jsp                   # JSP pages
│   ├── css/                    # Stylesheets
│   ├── js/                     # JavaScript files
│   ├── assets/                 # Images and icons
│   └── WEB-INF/               # Configuration and libraries
│       ├── lib/               # JAR dependencies
│       └── firebase-adminsdk.json # Firebase credentials
├── src/                        # Source code
├── nbproject/                  # NetBeans project files
├── lib/                        # External libraries
└── README.md                   # This file
```

## 🚀 Setup & Installation

### Prerequisites
- Java JDK 8 or higher
- Apache Tomcat 9.0+
- MySQL Server
- Apache Ant
- Firebase project

### 1. Clone the Repository
```bash
git clone <repository-url>
cd WebApplication1
```

### 2. Database Setup
```sql
-- Import the provided SQL file
mysql -u root -p < web_enterprise.sql
```

### 3. Firebase Setup
Follow the [Firebase Configuration](#firebase-configuration) section below.

### 4. Library Dependencies
Ensure these JAR files are in `web/WEB-INF/lib/`:
- `firebase-admin-9.2.0.jar`
- `google-auth-library-credentials-1.19.0.jar`
- `google-auth-library-oauth2-http-1.19.0.jar`
- `google-http-client-1.42.3.jar`
- `google-http-client-gson-1.42.3.jar`
- `gson-2.10.1.jar`
- `guava-32.1.2-jre.jar`
- `slf4j-api-2.0.7.jar`
- `mysql-connector-j-9.3.0.jar`
- `jakarta.servlet-api-5.0.0.jar`

## 🔥 Firebase Configuration

### Centralized Configuration
All Firebase configuration has been consolidated into `firebase_config.jsp` for easy maintenance and reuse.

### Setting Up Firebase

#### Step 1: Get Firebase Service Account
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `webapplication1-4bebd`
3. Click the gear icon (⚙️) → Project Settings
4. Go to "Service accounts" tab
5. Click "Generate new private key"
6. Download the JSON file
7. Rename to `firebase-adminsdk.json`
8. Place in: `web/WEB-INF/firebase-adminsdk.json`

#### Step 2: Security Configuration
```json
// firebase-adminsdk.json structure (template)
{
  "type": "service_account",
  "project_id": "webapplication1-4bebd",
  "private_key_id": "YOUR_PRIVATE_KEY_ID",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nYOUR_PRIVATE_KEY\\n-----END PRIVATE KEY-----\\n",
  "client_email": "firebase-adminsdk-xxxxx@webapplication1-4bebd.iam.gserviceaccount.com",
  // ... other fields
}
```

**⚠️ Security Notes:**
- Never commit `firebase-adminsdk.json` to version control
- Keep credentials secure and private
- File gives admin access to your Firebase project

### Firebase Utility Functions

#### Include in JSP Pages
```jsp
<!-- Include Firebase Configuration -->
<%@ include file="firebase_config.jsp" %>
```

#### Available Functions

##### Authentication
```javascript
// Login
const result = await window.FirebaseUtils.login(email, password);

// Register
const result = await window.FirebaseUtils.register(email, password, nama);

// Logout
const result = await window.FirebaseUtils.logout();

// Change Password
const result = await window.FirebaseUtils.changePassword(currentPassword, newPassword);
```

##### User Management
```javascript
// Get current user
const user = window.FirebaseUtils.getCurrentUser();

// Check login status
const isLoggedIn = window.FirebaseUtils.isLoggedIn();

// Get user data
const result = await window.FirebaseUtils.getUserData(uid);

// Update user data
const result = await window.FirebaseUtils.updateUserData(uid, userData);
```

##### Event Handling
```javascript
// Listen for authentication state changes
window.addEventListener('firebaseUserSignedIn', (event) => {
  console.log('User signed in:', event.detail);
});

window.addEventListener('firebaseUserSignedOut', () => {
  console.log('User signed out');
});

window.addEventListener('firebaseReady', () => {
  console.log('Firebase is ready');
});
```

## 🔨 Build & Deployment

### Apache Ant Commands
```bash
# Clean and build
ant clean build

# Build only
ant build

# Compile only
ant compile

# Run (clean build + deploy)
ant run

# Default target
ant
```

### Access Application
After deployment: http://localhost:8080/WebApplication1

## 📖 Usage Guide

### User Registration & Login
1. Navigate to the registration page
2. Fill in name, email, and password
3. Choose user or admin registration
4. Login with credentials

### Change Password
1. Login to your account
2. Go to main page
3. Click "Change Password"
4. Enter current and new passwords
5. System performs client-side re-authentication
6. Password updated via Firebase Admin SDK

### Admin Functions
- User management
- Item management
- Role updates
- Account administration

## 📚 API Documentation

### Firebase Utils API

#### Response Format
All Firebase utility functions return consistent response objects:
```javascript
{
  success: boolean,
  user?: FirebaseUser,      // For auth operations
  data?: any,               // For data operations
  error?: string            // Error message if failed
}
```

#### Authentication Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `login(email, password)` | `string, string` | `Promise<Response>` | Authenticate user |
| `register(email, password, nama)` | `string, string, string` | `Promise<Response>` | Register new user |
| `logout()` | none | `Promise<Response>` | Sign out user |
| `changePassword(current, new)` | `string, string` | `Promise<Response>` | Update password |

#### User Data Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `getCurrentUser()` | none | `FirebaseUser \| null` | Get current user |
| `isLoggedIn()` | none | `boolean` | Check auth status |
| `getUserData(uid)` | `string` | `Promise<Response>` | Fetch user data |
| `updateUserData(uid, data)` | `string, object` | `Promise<Response>` | Update user data |
| `waitForAuth()` | none | `Promise<FirebaseUser \| null>` | Wait for auth state |

## 🔒 Security Features

### Password Security
- Minimum 6 characters required
- Client-side validation
- Server-side verification
- Firebase Admin SDK integration

### Authentication Flow
1. **Client-side**: Firebase JS SDK authentication
2. **Server-side**: Session management
3. **Re-authentication**: Required for sensitive operations
4. **Admin SDK**: Server-side user management

### Access Control
- Session-based authorization
- Role-based permissions (admin/user)
- Protected admin routes
- Automatic session invalidation

## 🛠️ Troubleshooting

### Common Issues

#### JSP Compilation Errors
**Problem**: Missing Firebase Admin SDK JARs
**Solution**: Download and place all required JAR files in `web/WEB-INF/lib/`

#### Firebase Authentication Fails
**Problem**: Missing or invalid `firebase-adminsdk.json`
**Solution**: Download fresh credentials from Firebase Console

#### Build Failures
**Problem**: Missing dependencies
**Solution**: Check all JAR files are present and Tomcat is properly configured

### Debug Steps
1. Check Tomcat logs for errors
2. Verify Firebase credentials are valid
3. Ensure all dependencies are in place
4. Test database connectivity
5. Check session management

### Support Resources
- Firebase Documentation: https://firebase.google.com/docs
- Apache Tomcat: https://tomcat.apache.org/
- JSP Specification: https://jakarta.ee/specifications/pages/

## 🏗️ Development Guidelines

### Best Practices
1. Always include `firebase_config.jsp` before using Firebase functions
2. Use utility functions instead of direct Firebase calls
3. Handle both success and error cases
4. Listen to authentication state events
5. Use `waitForAuth()` for authentication-dependent operations

### Code Organization
- Centralized Firebase configuration
- Consistent error handling patterns
- Modular utility functions
- Event-driven architecture
- Clean separation of concerns

### Security Considerations
- Never expose Firebase credentials
- Validate all user inputs
- Use HTTPS in production
- Implement proper session management
- Regular security audits

## 📄 License

This project is licensed under the MIT License. See LICENSE file for details.

## 👥 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

**Project Status**: ✅ Active Development  
**Last Updated**: May 28, 2025  
**Version**: 1.0.0  

For questions or support, please open an issue in the repository.
