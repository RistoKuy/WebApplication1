<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is an admin
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    
    if (isLoggedIn == null || !isLoggedIn || isAdmin == null || !isAdmin) {
        // Not logged in or not an admin, redirect to login
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get admin information from session
    String adminName = (String) session.getAttribute("userName");
    String adminEmail = (String) session.getAttribute("userEmail");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard | Aplikasi JSP</title>
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
        
        .welcome-card {
            background-color: rgba(30, 30, 30, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            color: var(--text-primary);
        }
        
        .welcome-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(187, 134, 252, 0.2) !important;
            border-color: var(--accent-purple);
        }
        
        .feature-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            font-size: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.3);
            border-radius: 50%;
            background: linear-gradient(135deg, #bb86fc, #9546fa);
            margin-bottom: 15px;
        }
        
        .btn-action {
            background: linear-gradient(45deg, var(--accent-purple), var(--accent-blue));
            color: #000;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 1rem;
            transition: all 0.3s ease;
            margin-top: 15px;
        }
        
        .btn-action:hover {
            transform: translateY(-3px);
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
        
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
    
    <%
        // Get user ID from session
        String userID = (String) session.getAttribute("userID");
        String userName = "";
        
        // Connect to database to get most up-to-date user information
        java.sql.Connection conn = null;
        java.sql.PreparedStatement pstmt = null;
        java.sql.ResultSet rs = null;
        
        try {
            // Get database connection (replace with your actual connection code)
            conn = new com.mysql.jdbc.Driver().connect("jdbc:mysql://localhost:3306/web_enterprise", null);
            // Or use your connection pool if available
            // conn = yourConnectionPool.getConnection();
            
            // Query to get username from database
            String query = "SELECT nama FROM user WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                userName = rs.getString("nama");
            }
        } catch (Exception e) {
            // Log the exception
            e.printStackTrace();
            
            // Fallback to session username if database query fails
            userName = (String) session.getAttribute("userName");
            if (userName == null) userName = "User"; // Default name if all else fails
        } finally {
            // Close database resources
            try { if (rs != null) rs.close(); } catch (Exception e) { }
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
            try { if (conn != null) conn.close(); } catch (Exception e) { }
        }
        %>
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h5><i class="bi bi-code-square me-2"></i>Dashboard</h5>
        </div>
        <ul class="sidebar-menu">
            <li class="active"><a href="dashboard.jsp"><i class="bi bi-house me-2"></i>Home</a></li>
            <li><a href="account_list.jsp"><i class="bi bi-person-lines-fill me-2"></i>User</a></li>
            <li><a href="item_list.jsp"><i class="bi bi-box-seam me-2"></i>Item</a></li>
            <li><a href="admin_orders.jsp"><i class="bi bi-receipt me-2"></i>Invoice</a></li>
            <li><a href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <h1 class="neon-text">Selamat Datang, <%= adminName %> (Admin)</h1>
        
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="welcome-card">
                    <div class="feature-icon text-white">
                        <i class="bi bi-gear"></i>
                    </div>
                    <h4>Menu Master</h4>
                    <p>Gunakan menu di sebelah kiri untuk mengakses data pengguna.</p>
                    <a href="account_list.jsp" class="btn btn-action">
                        <i class="bi bi-arrow-right-circle me-2"></i>Lihat Data Pengguna
                    </a>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="welcome-card">
                    <div class="feature-icon text-white">
                        <i class="bi bi-person"></i>
                    </div>
                    <h4>Profil Pengguna</h4>
                    <p>Kelola informasi akun dan pengaturan profil Anda.</p>
                    <a href="account_update.jsp" class="btn btn-action">
                        <i class="bi bi-pencil-square me-2"></i>Edit Profil
                    </a>
                </div>
            </div>
        </div>
        
        <div class="welcome-card">
            <h4 class="mb-3">Aktivitas Terbaru</h4>
            <div class="d-flex align-items-center mb-3">
                <div class="me-3">
                    <i class="bi bi-check-circle-fill text-success fs-4"></i>
                </div>
                <div>
                    <h6 class="mb-1">Login Berhasil</h6>
                    <p class="mb-0 text-muted small"><%= new java.util.Date() %></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>