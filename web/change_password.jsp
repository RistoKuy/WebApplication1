<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.google.firebase.auth.FirebaseAuth"%>
<%@page import="com.google.firebase.auth.UserRecord"%>
<%@page import="com.google.firebase.auth.FirebaseAuthException"%>
<%@page import="com.google.firebase.FirebaseApp"%>
<%@page import="com.google.firebase.FirebaseOptions"%>
<%@page import="com.google.auth.oauth2.GoogleCredentials"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="util.EnvConfig"%>

<%
    String message = request.getParameter("message"); // For displaying messages
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // --- BEGIN SERVER-SIDE PROCESSING (from former _action.jsp) ---
        // Ensure Firebase is initialized
        if (FirebaseApp.getApps().isEmpty()) {
            try {
                String serviceAccountPath = application.getRealPath(EnvConfig.getFirebaseServiceAccountPath());
                java.io.File serviceAccountFile = new java.io.File(serviceAccountPath);
                
                if (!serviceAccountFile.exists()) {
                    message = "Error: Firebase service account file not found. Please place 'firebase-adminsdk.json' in the WEB-INF directory. Download it from Firebase Console > Project Settings > Service Accounts.";
                } else {
                    FileInputStream serviceAccount = new FileInputStream(serviceAccountFile);
                    FirebaseOptions options = new FirebaseOptions.Builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .setDatabaseUrl(EnvConfig.getFirebaseDatabaseUrl()) // Use environment configuration
                        .build();
                    FirebaseApp.initializeApp(options);
                    message = "Firebase initialized successfully.";
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Error: Firebase initialization failed. " + e.getMessage() + " Please ensure the firebase-adminsdk.json file is properly placed in WEB-INF directory.";
                // No redirect here, message will be displayed below
            }
        }

        if (message == null) { // Proceed only if initialization was successful or no prior error
            String currentPassword = request.getParameter("currentPassword"); // Still sent, but not used by Admin SDK for update
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");
            String userEmail = (String) session.getAttribute("userEmail");

            if (userEmail == null || userEmail.isEmpty()) {
                message = "Error: User not logged in. Please <a href='login.jsp'>login</a>.";
            } else if (newPassword == null || !newPassword.equals(confirmNewPassword)) {
                message = "Error: New passwords do not match.";
            } else if (newPassword.length() < 6) {
                message = "Error: New password must be at least 6 characters long.";
            } else {
                FirebaseAuth authInstance = FirebaseAuth.getInstance();
                try {
                    UserRecord.UpdateRequest updateRequest = new UserRecord.UpdateRequest(authInstance.getUserByEmail(userEmail).getUid())
                        .setPassword(newPassword);
                    authInstance.updateUser(updateRequest);
                    message = "Password updated successfully!";                } catch (FirebaseAuthException e) {
                    String errorMessagePrefix = "Error updating password: ";
                    if (e.getAuthErrorCode() != null) {
                        String errorCode = e.getAuthErrorCode().toString();
                        if ("USER_NOT_FOUND".equals(errorCode)) {
                            message = "Error: User not found.";
                        } else if ("WEAK_PASSWORD".equals(errorCode)) {
                            message = "Error: The new password is too weak.";
                        } else {
                            message = errorMessagePrefix + errorCode;
                        }
                    } else {
                        message = errorMessagePrefix + e.getMessage();
                    }
                } catch (Exception e) {
                    message = "Error: An unexpected error occurred. " + e.getMessage();
                }
            }
        }
        // --- END SERVER-SIDE PROCESSING ---
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Change Password | Aplikasi JSP</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --dark-bg: #121212;
            --dark-card: #1e1e1e;
            --accent-purple: #bb86fc;
            --text-primary: #e1e1e1;
        }
        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .change-password-container {
            background: var(--dark-card);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 2.5rem;
            color: var(--accent-purple);
            text-align: center;
        }
        .form-control {
            background-color: rgba(45, 45, 45, 0.7);
            color: var(--text-primary);
            border: 1px solid rgba(68, 68, 68, 0.5);
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        .form-control:focus {
            background-color: rgba(51, 51, 51, 0.8);
            border-color: var(--accent-purple);
            box-shadow: 0 0 0 0.25rem rgba(187, 134, 252, 0.25);
            outline: none;
        }
        .btn-submit {
            background: linear-gradient(45deg, var(--accent-purple), #9a67ea);
            color: #121212;
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            width: 100%;
        }
        .btn-submit:hover {
            background: linear-gradient(45deg, #9a67ea, var(--accent-purple));
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
        }
        .message {
            margin-top: 20px;
            text-align: center;
            padding: 10px;
            border-radius: 5px;
        }
        .message.success {
            background-color: rgba(76, 175, 80, 0.2); /* Greenish for success */
            color: #4CAF50;
        }
        .message.error {
            background-color: rgba(207, 102, 121, 0.2); /* Reddish for error */
            color: #cf6679;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: var(--accent-purple);
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="change-password-container">
        <h1>Change Password</h1>
        <%-- The form will now submit to itself --%>
        <form id="changePasswordForm" action="change_password.jsp" method="post">
            <div class="mb-3">
                <label for="currentPassword" class="form-label">Current Password (for client-side re-auth)</label>
                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
            </div>
            <div class="mb-3">
                <label for="newPassword" class="form-label">New Password</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
            </div>
            <div class="mb-3">
                <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
            </div>
            <button type="submit" class="btn-submit">Change Password</button>
        </form>
        <div id="messageDiv" class="message <% if (message != null) { out.print(message.startsWith("Error:") ? "error" : "success"); } %>">
            <%
                if (message != null) {
                    out.println("<p>" + message + "</p>");
                }
            %>
        </div>
        <a href="main.jsp" class="back-link">Back to Main Page</a>
    </div>    <script src="js/bootstrap.bundle.min.js"></script>
    
    <!-- Include Firebase Configuration -->
    <%@ include file="firebase_config.jsp" %>
    
    <script type="module">
      const messageDiv = document.getElementById('messageDiv');
      const changePasswordForm = document.getElementById('changePasswordForm');
      
      if (changePasswordForm) {
        changePasswordForm.addEventListener('submit', async function(e) {
          e.preventDefault(); // Prevent default JSP form submission initially

          const currentPasswordInput = document.getElementById('currentPassword');
          const newPasswordInput = document.getElementById('newPassword');
          const confirmNewPasswordInput = document.getElementById('confirmNewPassword');
          const currentPassword = currentPasswordInput.value;
          const newPassword = newPasswordInput.value;
          const confirmNewPassword = confirmNewPasswordInput.value;

          if (newPassword !== confirmNewPassword) {
            messageDiv.className = 'message error';
            messageDiv.innerHTML = '<p>Error: New passwords do not match.</p>';
            return;
          }
          if (newPassword.length < 6) {
            messageDiv.className = 'message error';
            messageDiv.innerHTML = '<p>Error: New password must be at least 6 characters long.</p>';
            return;
          }

          // Use Firebase utility function for password change
          const result = await window.FirebaseUtils.changePassword(currentPassword, newPassword);
          if (result.success) {
            messageDiv.className = 'message success';
            messageDiv.innerHTML = '<p>Password updated successfully!</p>';
            changePasswordForm.reset();
          } else {
            console.error('Client-side re-authentication failed:', result.error);
            messageDiv.className = 'message error';
            messageDiv.innerHTML = '<p>Error: Re-authentication failed. Check your current password. (' + result.error + ')</p>';
          }
        });
      }
    </script>
</body>
</html>
