<!-- filepath: d:\Project\WebApplication1\web\register_output.jsp -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.TestUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Register Result</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #121212;
            color: #e1e1e1;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .result-container {
            background: #1e1e1e;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.5);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            text-align: center;
        }
        .success-icon {
            font-size: 5rem;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        .error-icon {
            font-size: 5rem;
            color: #cf6679;
            margin-bottom: 20px;
        }
        .btn-return {
            background-color: #bb86fc;
            color: #121212;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-return:hover {
            background-color: #9a67ea;
        }
    </style>
</head>
<body>
    <div class="result-container">
    <%        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String isAdminParam = request.getParameter("isAdmin");
        boolean isAdmin = (isAdminParam != null && isAdminParam.equals("1"));
        
        // Check if email already exists using the utility function
        boolean emailExists = TestUtil.isEmailExists(email);
        
        if (emailExists) {
            // Email already exists, show error message
    %>
            <i class="bi bi-exclamation-triangle-fill error-icon"></i>
            <h2>Registration Failed</h2>
            <p>The email address <strong><%= email %></strong> is already registered.</p>
            <p>Please use a different email address or try to login with the existing account.</p>
            <div>
                <a href="register.jsp" class="btn-return">Back to Registration</a>
            </div>
    <%
        } else {
            // Email doesn't exist, proceed with registration
            Connection conn = null;
            PreparedStatement pstmt = null;
            boolean success = false;
            
            try {
                // Register JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Open a connection
                String url = "jdbc:mysql://localhost:3306/web_enterprise";
                String user = "root";
                String dbPassword = "";
                
                conn = DriverManager.getConnection(url, user, dbPassword);
                  // SQL query to insert new user
                String sql = "INSERT INTO user (nama, email, password, is_admin) VALUES (?, ?, ?, ?)";
                
                // Create prepared statement
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nama);
                pstmt.setString(2, email);
                pstmt.setString(3, password);
                pstmt.setInt(4, isAdmin ? 1 : 0);
                
                // Execute the query
                int rowsAffected = pstmt.executeUpdate();
                success = (rowsAffected > 0);
                
                if (success) {
    %>
                    <i class="bi bi-check-circle-fill success-icon"></i>
                    <h2>Registration Successful</h2>
                    <p>Welcome, <strong><%= nama %></strong>! Your account has been created successfully.</p>
                    <p>You can now login using your email and password.</p>
                    <div>
                        <a href="login.jsp" class="btn-return">Proceed to Login</a>
                    </div>
    <%
                } else {
    %>
                    <i class="bi bi-exclamation-triangle-fill error-icon"></i>
                    <h2>Registration Failed</h2>
                    <p>We couldn't create your account at this time. Please try again later.</p>
                    <div>
                        <a href="register.jsp" class="btn-return">Back to Registration</a>
                    </div>
    <%
                }
            } catch(Exception e) {
    %>
                <i class="bi bi-exclamation-triangle-fill error-icon"></i>
                <h2>Error</h2>
                <p><%= e.getMessage() %></p>
                <div>
                    <a href="register.jsp" class="btn-return">Back to Registration</a>
                </div>
    <%
            } finally {
                try {
                    if(pstmt != null) pstmt.close();
                    if(conn != null) conn.close();
                } catch(SQLException se) {
                    out.println("<p>Error closing resources: " + se.getMessage() + "</p>");
                }
            }
        }
    %>
    </div>
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>