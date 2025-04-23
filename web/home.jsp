<%-- 
    Document   : home
    Created on : 23 Apr 2025, 11.31.51
    Author     : Aristo Baadi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Beranda | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Aplikasi JSP</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="#">Beranda</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Tentang</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Kontak</a></li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Konten-->
    <div class="container text-center py-5">
        <h1 class="fw-bold">Selamat Datang</h1>
        <p class="lead">Halaman utama aplikasi JSP dengan Bootstrap lokal.</p>
        <a href="login.jsp" class="btn btn-success btn-lg">Login Sekarang</a>
    </div>
    
    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-4 mt-5">
        <p class="mb-0">© 2025 Aplikasi JSP - Semua Hak Dilindungi</p>
    </footer>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>