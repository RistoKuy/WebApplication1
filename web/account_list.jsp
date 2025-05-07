<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Data Register | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Adding Bootstrap Icons CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <!-- Custom styles inside head -->
    <style>
        :root {
            --dark-bg: #121212;
            --dark-card: #1e1e1e;
            --dark-light: #2d2d2d;
            --accent-purple: #bb86fc;
            --accent-blue: #03dac6;
            --accent-pink: #cf6679;
            --text-primary: #e1e1e1;
            --text-secondary: #b0b0b0;
        }
        
        /* Hero section enhancements */
        .bg-gradient {
            position: relative;
            overflow: hidden;
            background: none !important;
        }
        
        /* Add the hero background image overlay */
        .hero-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://images.unsplash.com/photo-1745750747228-d7ae37cba3a5?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: -10;
            filter: brightness(0.6);
        }
        
        /* Page overlay to darken the background image slightly */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(18, 18, 18, 0.7), rgba(32, 10, 64, 0.8));
            z-index: -5;
        }
        
        body {
            background-color: transparent;
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar styling */
        .sidebar {
            width: 200px;
            background-color: rgba(18, 18, 18, 0.6);
            backdrop-filter: blur(15px);
            color: var(--text-primary);
            padding: 20px 0;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 10;
        }
        
        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }
        
        .sidebar-header h5 {
            color: var(--accent-purple);
            font-weight: bold;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .sidebar-menu li {
            padding: 10px 20px;
            transition: background-color 0.3s;
        }
        
        .sidebar-menu li a {
            color: var(--text-primary);
            text-decoration: none;
            display: block;
        }
        
        .sidebar-menu li:hover, .sidebar-menu li.active {
            background-color: rgba(187, 134, 252, 0.2);
        }
        
        .sidebar-menu li.active a {
            color: var(--accent-purple);
        }
        
        /* Main content styling */
        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 200px;
            background-color: transparent;
            position: relative;
            z-index: 5;
        }
        
        .data-table {
            background-color: rgba(30, 30, 30, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            color: var(--text-primary);
        }
        
        .data-table:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(187, 134, 252, 0.2) !important;
            border-color: var(--accent-purple);
        }
        
        .table {
            color: var(--text-primary);
        }
        
        .table th {
            background-color: rgba(45, 45, 45, 0.5);
            color: var(--accent-purple);
            border-color: rgba(255, 255, 255, 0.1);
        }
        
        .table td {
            border-color: rgba(255, 255, 255, 0.05);
        }
        
        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: rgba(45, 45, 45, 0.3);
        }
        
        .btn-edit {
            background-color: var(--accent-purple);
            color: #000;
            border: none;
            border-radius: 8px;
            padding: 6px 16px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        
        .btn-edit:hover {
            background-color: #9546fa;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
        }
        
        /* Neon text effect */
        .neon-text {
            color: var(--text-primary);
            text-shadow: 0 0 5px rgba(187, 134, 252, 0.5),
                         0 0 10px rgba(187, 134, 252, 0.3);
        }
        
        /* Smooth scroll behavior */
        html {
            scroll-behavior: smooth;
            scrollbar-color: var(--accent-purple) var(--dark-bg);
        }
        
        ::-webkit-scrollbar {
            width: 10px;
        }
        
        ::-webkit-scrollbar-track {
            background: var(--dark-bg);
        }
        
        ::-webkit-scrollbar-thumb {
            background: var(--accent-purple);
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
    
    <%
        // Check if user is logged in
        Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
        if (isLoggedIn == null || !isLoggedIn) {
            // Redirect to login page if not logged in
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userName = (String) session.getAttribute("userName");
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
            <h5><i class="bi bi-code-square me-2"></i>Dashboard</h5>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp"><i class="bi bi-house me-2"></i>Home</a></li>
            <li class="active"><a href="account_list.jsp"><i class="bi bi-person-lines-fill me-2"></i>Account</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="data-table">
            <h2 class="mb-4 neon-text">Account</h2>
            
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
                            <a href="admin_update_user.jsp?id=<%= id %>" class="btn btn-edit">
                                <i class="bi bi-pencil-square me-1"></i>Edit
                            </a>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4' class='text-center'>Error displaying data: " + e.getMessage() + "</td></tr>");
                        } finally {
                            // Close resources
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                out.println("<tr><td colspan='4' class='text-center'>Error closing resources: " + e.getMessage() + "</td></tr>");
                            }
                        }
                        
                        // If no records found, display message
                        if (rowNum == 1) {
                    %>
                    <tr>
                        <td colspan="4" class="text-center">No user data found.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>