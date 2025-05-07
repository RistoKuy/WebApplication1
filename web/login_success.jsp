<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Login Berhasil | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #121212; /* Warna latar belakang gelap */
            color: #e1e1e1; /* Warna teks terang */
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .success-container {
            background: #1e1e1e; /* Warna latar belakang container gelap */
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.5);
            padding: 40px;
            max-width: 800px;
            width: 100%;
            text-align: center;
        }
        .icon-success {
            font-size: 5rem;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 2.5rem;
        }
        .user-info {
            background-color: #2d2d2d;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }
        .info-label {
            font-weight: bold;
            color: #bb86fc;
        }
        .btn-dashboard {
            background-color: #bb86fc; /* Warna tombol */
            color: #121212; /* Warna teks tombol */
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
        }
        .btn-logout {
            background-color: #cf6679; /* Warna tombol logout */
            color: #ffffff;
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
        }
        .btn-dashboard:hover {
            background-color: #9a67ea; /* Warna tombol saat hover */
        }
        .btn-logout:hover {
            background-color: #b55a6a; /* Warna tombol logout saat hover */
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
        
        // Get user info from session
        String userName = (String) session.getAttribute("userName");
        String userEmail = (String) session.getAttribute("userEmail");
    %>
    <div class="success-container">
        <i class="bi bi-check-circle-fill icon-success"></i>
        <h1>Login Berhasil!</h1>
        <p class="lead">Selamat datang kembali, <strong><%= userName %></strong>. Anda telah berhasil login ke Aplikasi JSP.</p>
        
        <div class="user-info">
            <div class="mb-3">
                <span class="info-label">Nama: </span>
                <span><%= userName %></span>
            </div>
            <div class="mb-3">
                <span class="info-label">Email: </span>
                <span><%= userEmail %></span>
            </div>
            <div class="mb-3">
                <span class="info-label">Status: </span>
                <span>Aktif</span>
            </div>
            <div class="mb-3">
                <span class="info-label">Login Pada: </span>
                <span><%= new java.util.Date() %></span>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="index.jsp" class="btn-dashboard">
                <i class="bi bi-house-door me-2"></i>Halaman Utama
            </a>
            <a href="dashboard.jsp" class="btn-dashboard" style="background-color: #3f51b5;">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a>
            <a href="account_update.jsp" class="btn-dashboard" style="background-color: #03dac6;">
                <i class="bi bi-person-gear me-2"></i>Edit Profil
            </a>
            <a href="logout.jsp" class="btn-logout">
                <i class="bi bi-box-arrow-right me-2"></i>Logout
            </a>
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>