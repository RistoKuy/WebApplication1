<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Account Manager | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Adding Bootstrap Icons CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <!-- Custom styles inside head -->
    <style>
        :root {
            --dark-bg: #343a40;
            --dark-card: #1e1e1e;
            --dark-light: #2d2d2d;
            --text-primary: #e1e1e1;
            --text-secondary: #b0b0b0;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar styling */
        .sidebar {
            width: 200px;
            background-color: var(--dark-bg);
            color: var(--text-primary);
            padding: 20px 0;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
        }
        
        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .sidebar-menu li {
            padding: 10px 20px;
        }
        
        .sidebar-menu li a {
            color: var(--text-primary);
            text-decoration: none;
            display: block;
        }
        
        .sidebar-menu li:hover, .sidebar-menu li.active {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        /* Main content styling */
        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 200px;
            background-color: #f8f9fa;
        }
        
        .data-table {
            background-color: white;
            border-radius: 5px;
            padding: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .table th {
            background-color: #f8f9fa;
        }
        
        .btn-edit {
            background-color: #ffc107;
            color: #212529;
            border: none;
            border-radius: 4px;
            padding: 5px 15px;
            font-size: 0.875rem;
        }
        
        .btn-edit:hover {
            background-color: #e0a800;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
        if (isLoggedIn == null || !isLoggedIn) {
            // Redirect to login page if not logged in
            response.sendRedirect("login.jsp");
            return;
        }
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // Load the database driver
            Class.forName("com.mysql.jdbc.Driver");
            
            // Connect to the database
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String dbUser = "root";
            String dbPassword = "";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
            
            // Create SQL statement
            stmt = conn.createStatement();
            String sql = "SELECT id, nama, email FROM user";
            
            // Execute the query
            rs = stmt.executeQuery(sql);
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h5>Dashboard</h5>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp">Home</a></li>
            <li class="active"><a href="account_list.jsp">Account</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="data-table">
            <h2 class="mb-4">Account Manager</h2>
            
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Nama</th>
                        <th>Email</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int rowNum = 1;
                        try {
                            while (rs != null && rs.next()) {
                                int id = rs.getInt("id");
                                String nama = rs.getString("nama");
                                String email = rs.getString("email");
                    %>
                    <tr>
                        <td><%= rowNum++ %></td>
                        <td><%= nama %></td>
                        <td><%= email %></td>
                        <td>
                            <a href="admin_update_user.jsp?id=<%= id %>" class="btn btn-edit">Edit</a>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("Error displaying data: " + e.getMessage());
                        } finally {
                            // Close resources
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                out.println("Error closing resources: " + e.getMessage());
                            }
                        }
                        
                        // If no records found, display sample data
                        if (rowNum == 1) {
                    %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>