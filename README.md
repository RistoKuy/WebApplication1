# WebApplication1 - JSP Enterprise Web Application

A modern JSP-based web application with Firebase authentication, user management, and e-commerce functionality.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Environment Configuration](#environment-configuration)
- [Setup & Installation](#setup--installation)
- [Firebase Configuration](#firebase-configuration)
- [Build & Deployment](#build--deployment)
- [Usage Guide](#usage-guide)
- [API Documentation](#api-documentation)
- [Security Features](#security-features)
- [Feature Comparison](#feature-comparison)
- [Advanced Configuration](#advanced-configuration)
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
- ✅ Product catalog with image support
- ✅ Shopping cart functionality
- ✅ Complete checkout system
- ✅ Order management system
- ✅ Order tracking and status updates
- ✅ Item management (admin)
- ✅ User account management
- ✅ Stock management and automatic updates

### Order Management Features
- ✅ Complete order processing system
- ✅ Multi-item checkout with unique checkout IDs
- ✅ Order status tracking (pending, completed, cancelled)
- ✅ Customer information management
- ✅ Payment and delivery method selection
- ✅ Order cancellation with automatic stock restoration
- ✅ Admin order management and status updates
- ✅ Detailed order history and tracking
### Security Features
- ✅ Client-side re-authentication
- ✅ Server-side validation
- ✅ Password strength requirements
- ✅ Secure Firebase Admin SDK integration
- ✅ Session-based access control

### UI/UX
- ✅ Modern dark theme design
- ✅ Responsive Bootstrap layout
- ✅ Interactive animations and hover effects
- ✅ User-friendly forms and modals
- ✅ Image preview functionality with zoom controls
- ✅ Sidebar navigation for admin panel
- ✅ Neon text effects and gradient backgrounds

## 📁 Project Structure

```
WebApplication1/
├── build/                      # Compiled output
├── web/                        # Web application root
│   ├── *.jsp                   # JSP pages (30+ pages)
│   │   ├── account_*.jsp       # User account management
│   │   ├── admin_*.jsp         # Admin management pages
│   │   ├── cart.jsp            # Shopping cart
│   │   ├── checkout.jsp        # Order checkout
│   │   ├── *_orders.jsp        # Order management
│   │   ├── *_order_detail.jsp  # Order details
│   │   └── *_order_actions.jsp # Order CRUD operations
│   ├── css/                    # Bootstrap & custom styles
│   ├── js/                     # JavaScript files
│   ├── assets/                 # Images and icons
│   ├── uploads/                # User uploaded files
│   └── WEB-INF/               # Configuration and libraries
│       ├── lib/               # JAR dependencies
│       └── firebase-adminsdk.json # Firebase credentials
├── src/                        # Source code
├── nbproject/                  # NetBeans project files
├── lib/                        # External libraries
├── uploads/                    # Product image uploads
├── web_enterprise.sql          # Database schema
└── README.md                   # This file
```

## 🔧 Environment Configuration

**Important**: This application uses environment variables for configuration. You must set up your environment before running the application.

### Quick Setup
```bash
# 1. Copy environment template
copy .env.example .env

# 2. Edit .env with your actual values
# Update database credentials, Firebase keys, etc.

# 3. Ensure Firebase service account file is in place
# Place firebase-adminsdk.json in web/WEB-INF/
```

📖 **For detailed configuration instructions, see [ENVIRONMENT_CONFIG.md](ENVIRONMENT_CONFIG.md)**

---

## 🚀 Setup & Installation

### Quick Start (Development)

For rapid development setup:

```bash
# 1. Clone and navigate to project
cd c:\Project\WebApplication1

# 2. Start MySQL service
net start mysql

# 3. Import database schema
mysql -u root -p < web_enterprise.sql

# 4. Build and deploy
ant clean build

# 5. Start Tomcat and access application
# http://localhost:8080/WebApplication1
```

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

#### Database Schema Overview
The application uses a MySQL database with the following key tables:
- **users**: User account information and roles
- **item**: Product catalog with images and stock
- **order**: Order management with customer details
- **Additional tables**: For user preferences and system configuration

#### Required Database Configuration
- Database name: `web_enterprise`
- Default user: `root` (no password for development)
- Ensure MySQL server is running on localhost:3306

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

### 5. File Upload Setup
Create and configure the uploads directory:
```bash
mkdir uploads
# Ensure write permissions for Tomcat user
# On Windows, verify folder permissions allow file creation
```

The `uploads/` directory stores:
- Product images uploaded by administrators
- User-generated content
- System-generated files

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

### Production Deployment Checklist

#### Security Configuration
- [ ] Update Firebase credentials for production
- [ ] Configure HTTPS/SSL certificates
- [ ] Update database credentials
- [ ] Enable error logging
- [ ] Disable debug output

#### Database Setup
- [ ] Create production database
- [ ] Import schema with `web_enterprise.sql`
- [ ] Configure database user with minimal privileges
- [ ] Set up database backup procedures

#### File System
- [ ] Configure uploads directory with proper permissions
- [ ] Set up log rotation
- [ ] Configure backup procedures for uploaded files

#### Performance
- [ ] Configure connection pooling
- [ ] Set up monitoring and alerting
- [ ] Optimize image storage and delivery
- [ ] Configure caching where appropriate

## 📖 Usage Guide

### Application Pages Overview

#### Public Pages
- `index.jsp` - Landing page
- `login.jsp` - User authentication
- `register.jsp` - New user registration

#### User Pages
- `main.jsp` - Main shopping interface
- `item_list.jsp` - Product catalog
- `cart.jsp` - Shopping cart management
- `checkout.jsp` - Order processing
- `user_orders.jsp` - Order history
- `user_order_detail.jsp` - Detailed order view
- `change_password.jsp` - Password management
- `update_profile.jsp` - Profile updates

#### Admin Pages
- `dashboard.jsp` - Admin control panel
- `account_list.jsp` - User management
- `admin_add_user.jsp` - Add new users
- `admin_update_user.jsp` - Edit user information
- `admin_delete_user.jsp` - Remove users
- `admin_update_role.jsp` - Role management
- `item_list.jsp` - Product management
- `admin_add_item.jsp` - Add new products
- `admin_update_item.jsp` - Edit products
- `admin_delete_item.jsp` - Remove products
- `admin_orders.jsp` - Order management dashboard
- `admin_order_detail.jsp` - Detailed order management

#### Action Handlers
- `user_order_actions.jsp` - User order operations
- `admin_order_actions.jsp` - Admin order operations
- `login_output.jsp` - Authentication processing
- `register_output.jsp` - Registration processing

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
- Item management with image upload
- Order management and status updates
- Role updates
- Account administration
- Complete order tracking and control

### Shopping & Order Management

#### For Users:
1. **Browse Products**: View item catalog with images and details
2. **Shopping Cart**: Add items, modify quantities, view cart
3. **Checkout Process**:
   - Enter delivery information (name, address, phone)
   - Select payment method (Debit/Credit, QRIS, Bank Transfer, COD)
   - Choose delivery method (Standard, Express, Same Day)
   - Complete order with automatic stock deduction
4. **Order Tracking**:
   - View order history with status tracking
   - Access detailed order information
   - Cancel pending orders (with automatic stock restoration)

#### For Admins:
1. **Order Management Dashboard**: View all customer orders
2. **Status Updates**: Change order status (pending → completed/cancelled)
3. **Order Details**: Access complete order information and customer data
4. **Order Deletion**: Remove orders with automatic stock restoration

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

### Order Management API

#### Order Actions (User)
- **cancel_checkout**: Cancel an entire checkout (all items)
- **cancel_order**: Cancel individual order item (legacy support)

#### Order Actions (Admin)
- **update_checkout_status**: Update status for all orders in a checkout
- **delete_checkout**: Delete entire checkout with stock restoration
- **update_order_status**: Update individual order status (legacy support)

#### Order Status Values
- `pending`: Order placed, awaiting processing
- `completed`: Order fulfilled and delivered
- `cancelled`: Order cancelled, stock restored

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

#### Order System Issues
**Problem**: Orders not appearing or processing incorrectly
**Solution**: 
- Verify database connectivity
- Check Firebase UID session handling
- Ensure MySQL database has proper schema (run web_enterprise.sql)
- Check for transaction rollback errors in logs

#### Image Upload Problems
**Problem**: Product images not displaying
**Solution**: 
- Verify `uploads/` directory exists and has write permissions
- Check file path references in database
- Ensure image files are in correct format (PNG, JPG)

#### Stock Management Issues
**Problem**: Stock not updating correctly
**Solution**:
- Check for transaction conflicts
- Verify auto-commit settings in database operations
- Monitor for incomplete order cancellations

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

## 🚀 Feature Comparison

| Feature | User Access | Admin Access | Description |
|---------|-------------|--------------|-------------|
| **Authentication** | ✅ Login/Register | ✅ Full Control | Firebase-based auth system |
| **Product Browsing** | ✅ View Catalog | ✅ Full Management | Browse and search products |
| **Shopping Cart** | ✅ Add/Remove Items | ❌ View Only | Cart management with quantities |
| **Order Placement** | ✅ Checkout Process | ❌ No Direct Orders | Complete order workflow |
| **Order Tracking** | ✅ Own Orders | ✅ All Orders | View order history and details |
| **Order Management** | ✅ Cancel Pending | ✅ Full Control | Status updates and cancellations |
| **User Management** | ✅ Own Profile | ✅ All Users | Account and role management |
| **Product Management** | ❌ Read Only | ✅ CRUD Operations | Add, edit, delete products |
| **Stock Management** | ❌ View Only | ✅ Full Control | Inventory tracking and updates |
| **Image Upload** | ❌ Not Available | ✅ Product Images | File upload for product catalog |
| **Reports & Analytics** | ✅ Personal Stats | ✅ System-wide | Order and user analytics |

## 🔧 Advanced Configuration

### Environment-Specific Settings

#### Development Environment
- Debug mode enabled
- Detailed error messages
- Local database connection
- File upload to local directory

#### Production Environment
- Error logging to files
- Secure database connections
- HTTPS enforcement
- Cloud storage for uploads

### Performance Optimization
- Database connection pooling
- Image compression for uploads
- Session management optimization
- Caching strategies for frequently accessed data

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
**Last Updated**: May 30, 2025  
**Version**: 2.0.0  

For questions or support, please open an issue in the repository.
