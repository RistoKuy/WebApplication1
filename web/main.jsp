<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%-- Shop Page: Show Item List --%>
<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Toko Online | Aplikasi JSP</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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
        
        .bg-gradient {
            position: relative;
            overflow: hidden;
            background: none !important;
        }
        
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
        
        .text-muted {
            color: var(--text-secondary) !important;
        }
        
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
        
        .neon-text {
            color: var(--text-primary);
            text-shadow: 0 0 5px rgba(187, 134, 252, 0.5),
                         0 0 10px rgba(187, 134, 252, 0.3);
        }
    </style>
</head>
<body>
    <div class="hero-background"></div>
    <div class="overlay"></div>
    <nav class="navbar navbar-expand-lg shadow fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-shop me-2"></i>Toko JSP
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <!-- <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">
                            <i class="bi bi-house-door me-1"></i>Beranda
                        </a>
                    </li> -->
                    <li class="nav-item ms-2">
                        <span class="nav-link fw-semibold">Selamat Datang</span>
                    </li>
                    <!-- <li class="nav-item ms-2">
                        <a class="nav-link fw-semibold" href="update_profile.jsp">
                            <i class="bi bi-person-circle me-1"></i> Profil
                        </a>
                    </li> -->
                    <li class="nav-item ms-2">
                        <a class="nav-link fw-semibold" href="change_password.jsp">
                            <i class="bi bi-key me-1"></i> Change Password
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <%-- Show cart quantity badge --%>
                        <a class="nav-link fw-semibold position-relative" href="cart.jsp">
                            <i class="bi bi-cart4 me-1"></i> Keranjang
                            <% 
                            List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
                            int cartQty = 0;
                            if (cart != null) {
                                for (Map<String, Object> item : cart) {
                                    cartQty += (int) item.get("jumlah");
                                }
                            }
                            if (cartQty > 0) { %>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:0.8rem;">
                                <%= cartQty %>
                            </span>
                            <% } %>
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
    <% 
    String cartSuccess = (String) session.getAttribute("cartSuccess");
    if (cartSuccess != null) {
    %>
    <div class="container mt-3" style="padding-top: 80px;">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= cartSuccess %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
    <%
        session.removeAttribute("cartSuccess");
    }
    %>
    <!-- Hero Section -->
    <div class="py-5 bg-gradient" style="padding-top: 8rem !important;">
        <div class="container text-center py-5">
            <h1 class="display-4 fw-bold text-white mb-3 neon-text">Toko Online JSP</h1>
            <p class="lead text-white opacity-90 mb-4">Temukan berbagai produk menarik di toko kami!</p>
        </div>
    </div>
    <!-- Item List Section -->
    <div class="container py-5">
        <div class="row text-center mb-5">
            <div class="col-lg-8 mx-auto">
                <h2 class="fw-bold neon-text">Daftar Produk</h2>
                <p class="lead text-white">Belanja produk terbaik dengan harga terjangkau.</p>
            </div>
        </div>
        <div class="row g-4">
            <% 
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/web_enterprise";
                String dbUser = "root";
                String dbPassword = "";
                conn = DriverManager.getConnection(url, dbUser, dbPassword);
                String sql = "SELECT * FROM item ORDER BY id_brg DESC";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                boolean hasItem = false;
                while(rs.next()) {
                    hasItem = true;
                    int id_brg = rs.getInt("id_brg");
                    String nama_brg = rs.getString("nama_brg");
                    String deskripsi = rs.getString("deskripsi");
                    String harga = rs.getString("harga");
                    int stok = rs.getInt("stok");
                    String gambar_brg = rs.getString("gambar_brg");
                    // Format harga ke format "Rp 100.000"
                    String hargaFormatted = "Rp " + String.format("%,d", Integer.parseInt(harga)).replace(',', '.');
            %>
            <div class="col-md-4">
                <div class="card border-0 shadow h-100">
                    <div class="card-body text-center p-4">
                        <div class="mb-3">                            <% if(gambar_brg != null && !gambar_brg.isEmpty()) { %>
                                <img src="uploads/<%= gambar_brg %>" alt="<%= nama_brg %>" class="img-fluid rounded" style="max-height: 180px; object-fit: contain; background: #222;">
                            <% } else { %>
                                <span class="text-muted">No image</span>
                            <% } %>
                        </div>
                        <h5 class="card-title fw-bold"><%= nama_brg %></h5>
                        <p class="card-text text-white small"><%= deskripsi %></p>
                        <div class="mb-2">
                            <span class="fw-bold text-white">Harga: <%= hargaFormatted %></span>
                        </div>
                        <div class="mb-2">
                            <span class="badge bg-success">Stok: <%= stok %></span>
                        </div>
                        <form method="post" action="cart.jsp" style="display:inline;">
                            <input type="hidden" name="id_brg" value="<%= id_brg %>" />
                            <input type="hidden" name="nama_brg" value="<%= nama_brg %>" />
                            <input type="hidden" name="harga" value="<%= harga %>" />
                            <input type="hidden" name="gambar_brg" value="<%= gambar_brg %>" />
                            <input type="hidden" name="stok" value="<%= stok %>" />
                            <input type="hidden" name="from" value="main.jsp" />
                            <button type="submit" class="btn btn-primary rounded-pill px-4" <%= (stok > 0 ? "" : "disabled") %>>
                                <i class="bi bi-cart"></i> Beli
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <% }
                if (!hasItem) { %>
                <div class="col-12 text-center">
                    <div class="alert alert-info">Belum ada produk tersedia.</div>
                </div>
            <% }
            } catch(Exception e) { %>
                <div class="col-12 text-center">
                    <div class="alert alert-danger">Gagal menampilkan produk: <%= e.getMessage() %></div>
                </div>
            <% } finally {
                try { if(rs != null) rs.close(); } catch(Exception e) {}
                try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
                try { if(conn != null) conn.close(); } catch(Exception e) {}
            } %>
        </div>
    </div>
    <!-- Footer -->
    <footer class="py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5 class="mb-3 text-white">Toko JSP</h5>
                    <p class="text-muted">Aplikasi web toko online berbasis Java Server Pages dengan Bootstrap.</p>
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
                        <li><i class="bi bi-envelope me-2"></i>info@tokojsp.com</li>
                        <li><i class="bi bi-phone me-2"></i>+62 123 4567 890</li>
                    </ul>
                </div>
            </div>
            <hr class="my-4" style="border-color: rgba(255, 255, 255, 0.1);">
            <div class="row align-items-center">
                <div class="col-md-6 text-md-start">
                    <p class="small mb-0 text-muted">© 2025 Toko JSP. Hak Cipta Dilindungi.</p>
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
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>