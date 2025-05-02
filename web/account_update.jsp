<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Edit Profile | Aplikasi JSP</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #121212;
            color: #e1e1e1;
            min-height: 100vh;
            padding-top: 80px;
        }
        .form-container {
            background: #1e1e1e;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.5);
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
        }
        .form-control {
            background-color: #2d2d2d;
            color: #e1e1e1;
            border: 1px solid #444;
            border-radius: 8px;
        }
        .form-control:focus {
            background-color: #333;
            border-color: #bb86fc;
            color: #e1e1e1;
        }
        .btn-update {
            background-color: #bb86fc;
            color: #121212;
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-update:hover {
            background-color: #9a67ea;
        }
        .btn-cancel {
            background-color: transparent;
            color: #e1e1e1;
            border: 1px solid #444;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-cancel:hover {
            background-color: #444;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
        if (isLoggedIn == null || !isLoggedIn) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get user email from session
        String userEmail = (String) session.getAttribute("userEmail");
        String userName = "";
        String userPassword = "";
        
        // Include database connection
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Open a connection
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String dbUser = "root";
            String dbPassword = "";
            
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
            
            // Get current user data
            String sql = "SELECT * FROM user WHERE email = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userEmail);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                userName = rs.getString("nama");
                userPassword = rs.getString("password");
            }
        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    %>

    <div class="container">
        <div class="form-container">
            <h1 class="mb-4">Edit Profile</h1>
            
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill me-2"></i>Profile updated successfully!
                </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getParameter("error") %>
                </div>
            <% } %>
            
            <form action="update_profile.jsp" method="post">
                <div class="mb-3">
                    <label for="nama" class="form-label">Your Name</label>
                    <input type="text" class="form-control" id="nama" name="nama" value="<%= userName %>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= userEmail %>" readonly>
                    <small class="text-muted">Email cannot be changed</small>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" value="<%= userPassword %>" required>
                </div>
                <div class="mb-3">
                    <label for="confirm_password" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" value="<%= userPassword %>" required>
                </div>
                <div class="mt-4 d-flex justify-content-between">
                    <a href="login_success.jsp" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-update">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="js/bootstrap.bundle.min.js"></script>
    <script>
        // Simple password validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>