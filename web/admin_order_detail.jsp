<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%-- Admin Order Detail Page --%>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isLoggedIn == null || !isLoggedIn || isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }

    String invoiceIdStr = request.getParameter("invoice_id");
    String orderIdStr = request.getParameter("order_id");
    
    if (invoiceIdStr == null || orderIdStr == null) {
        response.sendRedirect("admin_orders.jsp");
        return;
    }
    
    int invoiceId = Integer.parseInt(invoiceIdStr);
    int orderId = Integer.parseInt(orderIdStr);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Detail Invoice & Order | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Adding Bootstrap Icons CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <!-- Custom styles -->
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
        
        /* Hero background */
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
            min-height: 100vh;
            padding: 30px;
        }
        
        .detail-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .detail-card {
            background-color: rgba(30, 30, 30, 0.8);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(187, 134, 252, 0.2);
        }
        
        .section-title {
            color: var(--accent-purple);
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            text-shadow: 0 0 5px rgba(187, 134, 252, 0.5);
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: bold;
            color: var(--accent-blue);
            min-width: 150px;
        }
        
        .info-value {
            color: var(--text-primary);
            flex: 1;
            text-align: right;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-pending {
            background-color: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }
        
        .status-completed {
            background-color: rgba(40, 167, 69, 0.2);
            color: #28a745;
            border: 1px solid #28a745;
        }
        
        .btn-back {
            background-color: var(--accent-purple);
            color: #000;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-back:hover {
            background-color: #9546fa;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
            color: #000;
        }
        
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
    
    <div class="detail-container">
        <div class="mb-4">
            <a href="admin_orders.jsp" class="btn-back">
                <i class="bi bi-arrow-left"></i> Kembali ke Manajemen Invoice
            </a>
        </div>
        
        <h1 class="neon-text mb-4">Detail Invoice & Order</h1>
        
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
            
            // Get invoice details
            String invoiceSql = "SELECT * FROM `invoice` WHERE id_invoice = ?";
            pstmt = conn.prepareStatement(invoiceSql);
            pstmt.setInt(1, invoiceId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String statusOrder = rs.getString("status_order");
        %>
        
        <!-- Invoice Information -->
        <div class="detail-card">
            <h3 class="section-title">Informasi Invoice</h3>
            <div class="info-row">
                <span class="info-label">ID Invoice:</span>
                <span class="info-value"><%= rs.getInt("id_invoice") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">ID Order:</span>
                <span class="info-value"><%= rs.getInt("id_order") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Firebase UID:</span>
                <span class="info-value"><%= rs.getString("firebase_uid") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Nama Penerima:</span>
                <span class="info-value"><%= rs.getString("nama_penerima") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Alamat:</span>
                <span class="info-value"><%= rs.getString("alamat") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">No. Telepon:</span>
                <span class="info-value"><%= rs.getString("no_telp") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Total Harga:</span>
                <span class="info-value">Rp <%= String.format("%,d", Integer.parseInt(rs.getString("total_harga"))).replace(',', '.') %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Status Order:</span>
                <span class="info-value">
                    <span class="status-badge <%= "completed".equals(statusOrder) ? "status-completed" : "status-pending" %>">
                        <%= statusOrder %>
                    </span>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Tanggal Invoice:</span>
                <span class="info-value"><%= rs.getTimestamp("tgl_invoice") %></span>
            </div>
        </div>
        
        <%
            }
            rs.close();
            pstmt.close();
            
            // Get order details
            String orderSql = "SELECT * FROM `order` WHERE id_order = ?";
            pstmt = conn.prepareStatement(orderSql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String orderStatus = rs.getString("status_order");
        %>
        
        <!-- Order Information -->
        <div class="detail-card">
            <h3 class="section-title">Informasi Order</h3>
            <div class="info-row">
                <span class="info-label">ID Order:</span>
                <span class="info-value"><%= rs.getInt("id_order") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">ID Barang:</span>
                <span class="info-value"><%= rs.getInt("id_brg") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Nama Barang:</span>
                <span class="info-value"><%= rs.getString("nama_brg") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Gambar Barang:</span>
                <span class="info-value"><%= rs.getString("gambar_brg") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Jumlah:</span>
                <span class="info-value"><%= rs.getInt("jumlah") %> pcs</span>
            </div>
            <div class="info-row">
                <span class="info-label">Harga Satuan:</span>
                <span class="info-value">Rp <%= String.format("%,d", Integer.parseInt(rs.getString("harga"))).replace(',', '.') %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Total Harga:</span>
                <span class="info-value">Rp <%= String.format("%,d", Integer.parseInt(rs.getString("total_harga"))).replace(',', '.') %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Metode Pengiriman:</span>
                <span class="info-value"><%= rs.getString("metode_pengiriman") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Metode Pembayaran:</span>
                <span class="info-value"><%= rs.getString("metode_pembayaran") %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Status Order:</span>
                <span class="info-value">
                    <span class="status-badge <%= "completed".equals(orderStatus) ? "status-completed" : "status-pending" %>">
                        <%= orderStatus %>
                    </span>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Tanggal Order:</span>
                <span class="info-value"><%= rs.getTimestamp("tgl_order") %></span>
            </div>
        </div>
        
        <%
            }
            
        } catch(Exception e) {
        %>
            <div class="detail-card">
                <div class="alert alert-danger">
                    <h4>Error</h4>
                    <p>Gagal mengambil data: <%= e.getMessage() %></p>
                    <a href="admin_orders.jsp" class="btn-back mt-3">
                        <i class="bi bi-arrow-left"></i> Kembali ke Manajemen Invoice
                    </a>
                </div>
            </div>
        <%
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException e) {
                e.printStackTrace();
            }
        }
        %>
        
        <div class="mt-4">
            <a href="admin_orders.jsp" class="btn-back">
                <i class="bi bi-arrow-left"></i> Kembali ke Manajemen Invoice
            </a>
        </div>
    </div>
    
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
