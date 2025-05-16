<%-- 
    Document   : home
    Created on : 23 Apr 2025, 11.31.51
    Author     : Aristo Baadi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    
    if (isLoggedIn == null || !isLoggedIn) {
        // Not logged in, redirect to login
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user information from session
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Beranda | Aplikasi JSP</title>
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
        }
        
        .navbar {
            padding: 0.8rem 1rem;
            background-color: rgba(18, 18, 18, 0.6) !important;
            backdrop-filter: blur(15px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            color: var(--accent-purple) !important;
        }
        
        .nav-link {
            font-size: 1.1rem;
            margin: 0 0.2rem;
            color: var(--text-primary) !important;
            transition: color 0.3s;
        }
        
        .nav-link:hover, .nav-link.active {
            color: var(--accent-purple) !important;
        }
        
        .btn-light {
            background-color: var(--dark-light);
            color: var(--text-primary);
            border: none;
        }
        
        .btn-light:hover {
            background-color: var(--accent-purple);
            color: #000;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, var(--accent-purple), var(--accent-blue));
            border: none;
        }
        
        .btn {
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
        }
        
        .bg-gradient {
            background: linear-gradient(135deg, #400080 0%, #0066a6 100%) !important;
        }
        
        .bg-light {
            background-color: var(--dark-light) !important;
        }
        
        .opacity-90 {
            opacity: 0.9;
        }
        
        /* Card styling */
        .card-title {
            font-size: 1.5rem;
            color: rgba(255, 255, 255);
        }

        .card {
            background-color: rgba(30, 30, 30, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(187, 134, 252, 0.2) !important;
            border-color: var(--accent-purple);
        }
        
        /* Feature icon styling */
        .feature-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 70px;
            height: 70px;
            font-size: 1.8rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.3);
            border-radius: 50%;
        }
        
        .icon-security {
            background: linear-gradient(135deg, #bb86fc, #9546fa);
        }
        
        .icon-performance {
            background: linear-gradient(135deg, #03dac6, #018786);
        }
        
        .icon-responsive {
            background: linear-gradient(135deg, #cf6679, #b4354e);
        }
        
        .text-muted {
            color: var(--text-secondary) !important;
        }
        
        /* CTA section */
        .cta-container {
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            background: rgba(24, 24, 24, 0.6);
            backdrop-filter: blur(15px);
        }
        
        /* Footer styling */
        footer {
            background-color: rgba(10, 10, 10, 0.8) !important;
            backdrop-filter: blur(15px);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        footer a.link-light {
            color: var(--text-secondary) !important;
            transition: color 0.3s;
        }
        
        footer a.link-light:hover {
            color: var(--accent-purple) !important;
        }
        
        footer .social-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--dark-light);
            transition: all 0.3s;
            margin-left: 10px;
        }
        
        footer .social-icon:hover {
            transform: translateY(-3px);
            background-color: var(--accent-purple);
            color: #000 !important;
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
        
        /* Neon text effect */
        .neon-text {
            color: var(--text-primary);
            text-shadow: 0 0 5px rgba(187, 134, 252, 0.5),
                         0 0 10px rgba(187, 134, 252, 0.3);
        }
    </style>
</head>
<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
    
    <!-- Enhanced Navbar with shadow and custom styling -->
    <nav class="navbar navbar-expand-lg shadow fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-code-square me-2"></i>Aplikasi JSP
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">                <ul class="navbar-nav ms-auto">
                    <li class="nav-item ms-2">
                        <span class="nav-link fw-semibold">Selamat Datang, <%= userName %> (User)</span>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="nav-link fw-semibold" href="update_profile.jsp">
                            <i class="bi bi-person-circle me-1"></i> Profil
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-light rounded-pill px-3" href="logout.jsp">
                            <i class="bi bi-box-arrow-right me-1"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
      <!-- Hero Section with Gradient Background -->
    <div class="py-5 bg-gradient" style="padding-top: 8rem !important;">
        <div class="container text-center py-5 glow-effect">
            <h1 class="display-4 fw-bold text-white mb-3 neon-text">Selamat Datang, <%= userName %></h1>
            <p class="lead text-white opacity-90 mb-4">Halaman utama aplikasi JSP untuk pengguna reguler.</p>
            <div class="mt-4">
                <a href="#features" class="btn btn-light btn-lg rounded-pill shadow px-5 py-3 fw-semibold">
                    <i class="bi bi-arrow-down-circle me-2"></i>Fitur Kami
                </a>
            </div>
        </div>
    </div>
    
    <!-- Features Section -->
    <div class="container py-5">
        <div class="row text-center mb-5">
            <div class="col-lg-8 mx-auto">
                <h2 class="fw-bold neon-text">Fitur Unggulan</h2>
                <p class="lead text-white">Aplikasi JSP ini dilengkapi berbagai fitur untuk memudahkan pengguna.</p>
            </div>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card border-0 shadow h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon icon-security text-white rounded-circle mb-4">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h5 class="card-title fw-bold">Keamanan Terjamin</h5>
                        <p class="card-text text-white">Sistem keamanan berlapis dengan enkripsi data yang kuat untuk melindungi informasi.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon icon-performance text-white rounded-circle mb-4">
                            <i class="bi bi-speedometer2"></i>
                        </div>
                        <h5 class="card-title fw-bold">Performa Tinggi</h5>
                        <p class="card-text text-white">Aplikasi dioptimalkan untuk memberikan pengalaman pengguna yang cepat dan responsif.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon icon-responsive text-white rounded-circle mb-4">
                            <i class="bi bi-phone"></i>
                        </div>
                        <h5 class="card-title fw-bold">Responsif</h5>
                        <p class="card-text text-white">Tampilan yang adaptif pada berbagai perangkat dari desktop hingga mobile.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- CTA Section -->
    <div class="py-5">
        <div class="container py-4">
            <div class="row align-items-center cta-container p-4">
                <div class="col-lg-8">
                    <h2 class="fw-bold neon-text">Siap untuk memulai?</h2>
                    <p class="lead mb-0">Daftar sekarang dan nikmati semua fitur yang tersedia.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <a href="register.jsp" class="btn btn-primary btn-lg px-4 rounded-pill shadow">
                        <i class="bi bi-person-plus me-2"></i>Daftar
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer class="py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5 class="mb-3 text-white">Aplikasi JSP</h5>
                    <p class="text-muted">Aplikasi web berbasis Java Server Pages dengan Bootstrap untuk tampilan yang menarik.</p>
                </div>
                <div class="col-md-3">
                    <h5 class="mb-3 text-white">Menu</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-decoration-none link-light">Beranda</a></li>
                        <li><a href="#" class="text-decoration-none link-light">Tentang</a></li>
                        <li><a href="#" class="text-decoration-none link-light">Kontak</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5 class="mb-3 text-white">Kontak</h5>
                    <ul class="list-unstyled">
                        <li><i class="bi bi-envelope me-2"></i>info@aplikasijsp.com</li>
                        <li><i class="bi bi-phone me-2"></i>+62 123 4567 890</li>
                    </ul>
                </div>
            </div>
            <hr class="my-4" style="border-color: rgba(255, 255, 255, 0.1);">
            <div class="row align-items-center">
                <div class="col-md-6 text-md-start">
                    <p class="small mb-0 text-muted">© 2025 Aplikasi JSP. Hak Cipta Dilindungi.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="social-icon text-decoration-none link-light"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-icon text-decoration-none link-light"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="social-icon text-decoration-none link-light"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="social-icon text-decoration-none link-light"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>
        </div>
    </footer>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>