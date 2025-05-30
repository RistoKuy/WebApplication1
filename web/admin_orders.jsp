<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%-- Admin Order Management Page --%>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isLoggedIn == null || !isLoggedIn || isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Order Management | Aplikasi JSP</title>
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
            font-weight: bold;        }
        
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
            margin-left: 200px;
            flex: 1;
            padding: 30px;
        }
        
        .data-table {
            background-color: rgba(30, 30, 30, 0.8);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .data-table:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(187, 134, 252, 0.2);        }
        
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
            margin-right: 5px;
        }
        
        .btn-edit:hover {
            background-color: #9546fa;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
        }
        
        .btn-delete {
            background-color: transparent;
            color: var(--accent-pink);
            border: 1px solid var(--accent-pink);
            border-radius: 8px;
            padding: 6px 16px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
          .btn-delete:hover {
            background-color: var(--accent-pink);
            color: #121212;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(207, 102, 121, 0.3);
        }
        
        .btn-info {
            background-color: transparent;
            color: var(--accent-blue);
            border: 1px solid var(--accent-blue);
            border-radius: 8px;
            padding: 6px 16px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn-info:hover {
            background-color: var(--accent-blue);
            color: #121212;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(3, 218, 198, 0.3);
        }
          .status-select {
            min-width: 120px;
            background-color: var(--dark-light);
            color: var(--text-primary);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
        }
        
        .status-select:focus {
            background-color: var(--dark-light);
            color: var(--text-primary);
            border-color: var(--accent-purple);
            box-shadow: 0 0 10px rgba(187, 134, 252, 0.3);
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
            border-radius: 4px;
        }
        
        h1 {
            margin-bottom: 30px;
        }
    </style>
</head>

<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
      <%
        // isLoggedIn is already declared at the top of the file
        String userName = (String) session.getAttribute("userName");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Connect to database for better security and flexibility
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String dbUser = "root";
            String dbPassword = "";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
        } catch (Exception e) {
            out.println("Database connection error: " + e.getMessage());
        }
    %>
    
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h5><i class="bi bi-code-square me-2"></i>Dashboard</h5>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp"><i class="bi bi-house me-2"></i>Home</a></li>
            <li><a href="account_list.jsp"><i class="bi bi-person-lines-fill me-2"></i>User</a></li>            <li><a href="item_list.jsp"><i class="bi bi-box-seam me-2"></i>Item</a></li>
            <li class="active"><a href="admin_orders.jsp"><i class="bi bi-receipt me-2"></i>Orders</a></li>
            <li><a href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->    <div class="main-content">
        <div class="data-table">
            <h1 class="neon-text">Manajemen Pesanan</h1>            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID Checkout</th>
                        <th>Tanggal</th>
                        <th>Nama Penerima</th>
                        <th>Total Harga</th>
                        <th>Status Order</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        // Group orders by id_checkout and get order summary
                        String sql = "SELECT id_checkout, MIN(tgl_order) as tgl_order, nama_penerima, SUM(CAST(total_harga AS UNSIGNED)) as grand_total, status_order, COUNT(*) as item_count FROM `order` GROUP BY id_checkout, nama_penerima, status_order ORDER BY MIN(tgl_order) DESC";
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();
                        boolean hasOrders = false;
                        while (rs.next()) {
                            hasOrders = true;
                            int checkoutId = rs.getInt("id_checkout");
                            String currentOrderStatus = rs.getString("status_order");
                            int itemCount = rs.getInt("item_count");
                    %>
                    <tr id="order-row-<%= checkoutId %>">
                        <td>#<%= checkoutId %></td>
                        <td><%= rs.getTimestamp("tgl_order") %></td>
                        <td><%= rs.getString("nama_penerima") %></td>
                        <td>Rp <%= String.format("%,d", rs.getLong("grand_total")).replace(',', '.') %> (<%= itemCount %> item<%= itemCount > 1 ? "s" : "" %>)</td>
                        <td>
                            <select class="form-select form-select-sm status-select" data-checkout-id="<%= checkoutId %>">
                                <option value="pending" <% if("pending".equals(currentOrderStatus)) { %>selected<% } %>>Pending</option>
                                <option value="completed" <% if("completed".equals(currentOrderStatus)) { %>selected<% } %>>Completed</option>
                                <option value="cancelled" <% if("cancelled".equals(currentOrderStatus)) { %>selected<% } %>>Cancelled</option>
                            </select>
                        </td>
                        <td>
                            <a href="admin_order_detail.jsp?id_checkout=<%= checkoutId %>" class="btn btn-info btn-sm me-2" title="Lihat Detail">
                                <i class="bi bi-eye"></i> Detail
                            </a>
                            <button class="btn btn-delete btn-sm delete-btn" data-checkout-id="<%= checkoutId %>" title="Hapus Order">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </td>
                    </tr>
                    <% }
                        if (!hasOrders) { %>
                        <tr><td colspan="6" class="text-center">Belum ada pesanan.</td></tr>
                    <% }
                        rs.close();
                        pstmt.close();
                    } catch(Exception e) { %>
                        <tr><td colspan="6" class="text-danger">Gagal mengambil data pesanan: <%= e.getMessage() %></td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script>        // Event listeners for status change and delete actions
        document.addEventListener('DOMContentLoaded', function() {
            // Handle status change
            document.querySelectorAll('.status-select').forEach(function(select) {
                select.addEventListener('change', function() {
                    const checkoutId = this.getAttribute('data-checkout-id');
                    const newStatus = this.value;
                    updateOrderStatus(checkoutId, newStatus);
                });
            });
            
            // Handle delete action
            document.querySelectorAll('.delete-btn').forEach(function(button) {
                button.addEventListener('click', function() {
                    const checkoutId = this.getAttribute('data-checkout-id');
                    deleteOrder(checkoutId);
                });
            });
        });

        function updateOrderStatus(checkoutId, newStatus) {
            if (confirm('Apakah Anda yakin ingin mengubah status pesanan ini?')) {
                fetch('admin_order_actions.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=update_checkout_status&id_checkout=' + checkoutId + '&status=' + newStatus
                })
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === 'success') {
                        alert('Status pesanan berhasil diperbarui!');
                    } else {
                        alert('Gagal memperbarui status pesanan: ' + data);
                        location.reload(); // Reload to restore original value
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Terjadi kesalahan saat memperbarui status');
                    location.reload();
                });
            } else {
                // User cancelled, reload to restore original value
                location.reload();
            }
        }        function deleteOrder(checkoutId) {
            if (confirm('Apakah Anda yakin ingin menghapus pesanan ini? Tindakan ini tidak dapat dibatalkan!')) {
                fetch('admin_order_actions.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete_checkout&id_checkout=' + checkoutId
                })
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === 'success') {
                        // Remove the row from the table
                        document.getElementById('order-row-' + checkoutId).remove();
                        alert('Pesanan berhasil dihapus!');
                        
                        // Check if there are no more orders
                        const tbody = document.querySelector('tbody');
                        if (tbody.children.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="6" class="text-center">Belum ada pesanan.</td></tr>';
                        }
                    } else {alert('Gagal menghapus pesanan: ' + data);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Terjadi kesalahan saat menghapus pesanan');
                });
            }
        }
    </script>
    
    <%
        // Close the database resources
        try {
            if(conn != null) conn.close();
        } catch(SQLException e) {
            out.println("Error closing database connection: " + e.getMessage());
        }
    %>
</body>
</html>
