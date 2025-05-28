<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login Verification</title>
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
    <%        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String isAdminParam = request.getParameter("isAdmin");
        boolean isAdminLogin = (isAdminParam != null && isAdminParam.equals("1"));

        if (!isAdminLogin) {
    %>
            <h2>Login Gagal</h2>
            <p>Only admin login is allowed here. Please login as a user from the login page.</p>
            <a href='login.jsp' class='btn-return'>Kembali ke Halaman Login</a>
    <%
        } else {
            // Database connection variables
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Register JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Open a connection
                String url = "jdbc:mysql://localhost:3306/web_enterprise";
                String user = "root";
                String dbPassword = "";

                conn = DriverManager.getConnection(url, user, dbPassword);

                // SQL query to check user credentials
                String sql = "SELECT * FROM user WHERE email = ? AND password = ?";

                // Create prepared statement
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);

                // Execute the query
                rs = pstmt.executeQuery();
                  // Check if user exists with correct credentials
                if (rs.next()) {
                    // Get user's name and admin status
                    String nama = rs.getString("nama");
                    boolean isAdminInDB = rs.getInt("is_admin") == 1;

                    // Check if admin login matches database
                    if (isAdminLogin && !isAdminInDB) {
                        // User tried to login as admin but isn't one
                        out.println("<h2>Login Gagal</h2>");
                        out.println("<p>Anda tidak memiliki hak akses sebagai Admin.</p>");
                        out.println("<a href='login.jsp' class='btn-return'>Kembali ke Halaman Login</a>");
                    } else {
                        // Set user session
                        session.setAttribute("userEmail", email);
                        session.setAttribute("userName", nama);
                        session.setAttribute("isAdmin", isAdminInDB);
                        session.setAttribute("loggedIn", true);

                        // Redirect based on user type
                        if (isAdminInDB) {
                            // Admin users go to dashboard
                            response.sendRedirect("dashboard.jsp");
                        } else {
                            // Regular users go to main page
                            response.sendRedirect("main.jsp");
                        }
                    }
                } else {
                    // Display error message for failed login
                    out.println("<h2>Login Gagal</h2>");
                    out.println("<p>Email atau password yang Anda masukkan salah.</p>");
                    out.println("<a href='login.jsp' class='btn-return'>Kembali ke Halaman Login</a>");
                }

            } catch(Exception e) {
                out.println("<h2>Error</h2>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("<a href='login.jsp' class='btn-return'>Kembali ke Halaman Login</a>");
            } finally {
                try {
                    if(rs != null) rs.close();
                    if(pstmt != null) pstmt.close();
                    if(conn != null) conn.close();
                } catch(SQLException se) {
                    out.println("<p>Error closing resources: " + se.getMessage() + "</p>");
                }
            }
        }
    %>
    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>