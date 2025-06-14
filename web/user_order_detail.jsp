<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="util.DatabaseUtil"%>
<%-- User Order Detail Page --%>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get firebase_uid from session
    String firebase_uid = (String) session.getAttribute("firebase_uid");
    if (firebase_uid == null || firebase_uid.isEmpty()) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail != null && !userEmail.isEmpty()) {
            firebase_uid = "email:" + userEmail;
            session.setAttribute("firebase_uid", firebase_uid);
        } else {
            response.sendRedirect("user_orders.jsp");
            return;
        }
    }    String checkoutIdStr = request.getParameter("id_checkout");
    
    if (checkoutIdStr == null) {
        response.sendRedirect("user_orders.jsp");
        return;
    }
    
    int checkoutId = Integer.parseInt(checkoutIdStr);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Detail Pesanan | Aplikasi JSP</title>
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
        
        .status-cancelled {
            background-color: rgba(220, 53, 69, 0.2);
            color: #dc3545;
            border: 1px solid #dc3545;
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
            color: #000;        }
        
        .neon-text {
            color: var(--text-primary);
            text-shadow: 0 0 5px rgba(187, 134, 252, 0.5),
                         0 0 10px rgba(187, 134, 252, 0.3);
        }
        
        /* Table styling */
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
        
        /* Image preview styling */
        .item-image-preview {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border-radius: 4px;
            border: 2px solid transparent;        }
        
        .item-image-preview:hover {
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(187, 134, 252, 0.6);
            border-color: var(--accent-purple);
        }
        
        /* Section separators for unified information */
        .info-section-separator {
            border-top: 1px solid rgba(187, 134, 252, 0.3);
            margin: 20px 0 15px 0;
            padding-top: 15px;
            position: relative;
        }
        
        .info-section-separator::before {
            content: '';
            position: absolute;
            top: -1px;
            left: 0;
            width: 50px;
            height: 2px;
            background: var(--accent-purple);
            border-radius: 1px;
        }
        
        .info-section-title {
            color: var(--accent-blue);
            font-size: 0.9rem;
            font-weight: bold;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
    </style>
</head>

<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
    
    <div class="detail-container">
        
        <h1 class="neon-text mb-4">Detail Pesanan</h1>        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // Declare variables for order data
        int orderIdData = 0;
        String namaPenerima = "";
        String alamat = "";
        String noTelp = "";
        String totalHarga = "";
        String statusOrder = "";
        String metodePengiriman = "";
        String metodePembayaran = "";
        java.sql.Timestamp tglOrder = null;
        String firebase_uid_db = "";
        String namaBrg = "";
        String gambarBrg = "";
        String harga = "";
        int jumlah = 0;
        int idBrg = 0;
        boolean hasValidData = false;
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");            conn = util.DatabaseUtil.getConnection();
              // Get order details by checkout ID - verify it belongs to current user
            String orderSql = "SELECT * FROM `order` WHERE id_checkout = ? AND firebase_uid = ?";
            pstmt = conn.prepareStatement(orderSql);
            pstmt.setInt(1, checkoutId);
            pstmt.setString(2, firebase_uid);
            rs = pstmt.executeQuery();
            
            // Get the first order to extract common information and calculate total
            int calculatedTotal = 0;
            if (rs.next()) {
                // Store common order data from first item
                orderIdData = rs.getInt("id_order");
                firebase_uid_db = rs.getString("firebase_uid");
                namaPenerima = rs.getString("nama_penerima");
                alamat = rs.getString("alamat");
                noTelp = rs.getString("no_telp");
                metodePengiriman = rs.getString("metode_pengiriman");
                metodePembayaran = rs.getString("metode_pembayaran");
                statusOrder = rs.getString("status_order");
                tglOrder = rs.getTimestamp("tgl_order");
                hasValidData = true;
                
                // Add first item's total to calculated total
                calculatedTotal += Integer.parseInt(rs.getString("total_harga"));
                
                // Continue with remaining items
                while (rs.next()) {
                    calculatedTotal += Integer.parseInt(rs.getString("total_harga"));
                }
                totalHarga = String.valueOf(calculatedTotal);
            }
        %>
        
        <% if (hasValidData) { %>
        <div class="detail-card">
            <h3 class="section-title">Informasi Pesanan</h3>
              <!-- Order Identification -->
            <div class="info-section-title">Identifikasi Pesanan</div>
            <div class="info-row">
                <span class="info-label">ID Checkout:</span>
                <span class="info-value">#<%= checkoutId %></span>
            </div>
            
            <!-- Customer Information -->
            <div class="info-section-separator">
                <div class="info-section-title">Informasi Penerima</div>
                <div class="info-row">
                    <span class="info-label">Nama Penerima:</span>
                    <span class="info-value"><%= namaPenerima %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Alamat Pengiriman:</span>
                    <span class="info-value"><%= alamat %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">No. Telepon:</span>
                    <span class="info-value"><%= noTelp %></span>
                </div>
            </div>
            
            <!-- Order Processing Details -->
            <div class="info-section-separator">
                <div class="info-section-title">Detail Pengiriman & Pembayaran</div>
                <div class="info-row">
                    <span class="info-label">Metode Pengiriman:</span>
                    <span class="info-value"><%= metodePengiriman %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Metode Pembayaran:</span>
                    <span class="info-value"><%= metodePembayaran %></span>
                </div>
            </div>
            
            <!-- Financial & Status Information -->
            <div class="info-section-separator">
                <div class="info-section-title">Status & Total</div>
                <div class="info-row">
                    <span class="info-label">Total Harga:</span>
                    <span class="info-value"><strong style="color: var(--accent-blue); font-size: 1.1em;">Rp <%= String.format("%,d", Integer.parseInt(totalHarga)).replace(',', '.') %></strong></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Status Pesanan:</span>
                    <span class="info-value">
                        <% if ("pending".equals(statusOrder)) { %>
                            <span class="status-badge status-pending">Pending</span>
                        <% } else if ("completed".equals(statusOrder)) { %>
                            <span class="status-badge status-completed">Completed</span>
                        <% } else if ("cancelled".equals(statusOrder)) { %>
                            <span class="status-badge status-cancelled">Cancelled</span>
                        <% } else { %>
                            <span class="status-badge"><%= statusOrder %></span>
                        <% } %>
                    </span>
                </div>
            </div>
            
            <!-- Timeline Information -->
            <div class="info-section-separator">
                <div class="info-section-title">Timeline</div>
                <div class="info-row">
                    <span class="info-label">Tanggal Pesanan:</span>
                    <span class="info-value"><%= tglOrder %></span>
                </div>
            </div>        </div>
        
        <!-- Item Details Table -->
        <div class="detail-card">
            <h3 class="section-title">Detail Barang</h3>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Nama Barang</th>
                        <th>Gambar</th>
                        <th>Harga Satuan</th>
                        <th>Jumlah</th>
                        <th>Total Harga</th>
                    </tr>
                </thead>                <tbody>
                    <%
                    // Query again to display all items in this checkout
                    PreparedStatement pstmtItems = null;
                    ResultSet rsItems = null;
                    try {
                        String itemsSql = "SELECT * FROM `order` WHERE id_checkout = ? AND firebase_uid = ?";
                        pstmtItems = conn.prepareStatement(itemsSql);
                        pstmtItems.setInt(1, checkoutId);
                        pstmtItems.setString(2, firebase_uid);
                        rsItems = pstmtItems.executeQuery();
                        
                        while (rsItems.next()) {
                            String itemNama = rsItems.getString("nama_brg");
                            String itemGambar = rsItems.getString("gambar_brg");
                            String itemHarga = rsItems.getString("harga");
                            int itemJumlah = rsItems.getInt("jumlah");
                            String itemTotal = rsItems.getString("total_harga");
                    %>
                    <tr>
                        <td><%= itemNama %></td>
                        <td>
                            <% 
                                if(itemGambar != null && !itemGambar.isEmpty()) { 
                            %>
                                <img src="uploads/<%= itemGambar %>" alt="<%= itemNama %>" height="60" 
                                    class="item-image-preview" data-bs-toggle="modal" data-bs-target="#imagePreviewModal"
                                    data-img-src="uploads/<%= itemGambar %>" data-img-name="<%= itemNama %>"
                                    style="cursor: pointer; border-radius: 4px; object-fit: contain; background: #222;">
                            <% } else { %>
                                <span class="text-muted">No image</span>
                            <% } %>
                        </td>
                        <td>Rp <%= String.format("%,d", Integer.parseInt(itemHarga)).replace(',', '.') %></td>
                        <td><%= itemJumlah %> pcs</td>
                        <td>Rp <%= String.format("%,d", Integer.parseInt(itemTotal)).replace(',', '.') %></td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' class='text-danger'>Error loading items: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rsItems != null) rsItems.close();
                        if (pstmtItems != null) pstmtItems.close();
                    }
                    %>
                </tbody></table>
        </div>
          <% } else { %>
            <div class="detail-card">
                <div class="alert alert-warning">
                    <h5>Data Tidak Ditemukan</h5>
                    <p>Checkout dengan ID #<%= checkoutId %> tidak ditemukan dalam sistem atau tidak dapat diakses.</p>
                    <p>Pastikan ID yang dimasukkan benar dan data masih tersedia.</p>
                </div>
            </div>
        <% } %>
        
        <%
        } catch(Exception e) {
        %>
            <div class="detail-card">
                <div class="alert alert-danger">
                    <h5>Error</h5>
                    <p>Gagal mengambil detail pesanan: <%= e.getMessage() %></p>
                </div>
            </div>
        <%        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException ex) {
                // Handle close exception
            }
        }
        %>
          <div class="mt-4">
            <a href="user_orders.jsp" class="btn-back">
                <i class="bi bi-arrow-left"></i> Kembali
            </a>
        </div>
    </div>
    
    <!-- Image Preview Modal -->
    <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-labelledby="imagePreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content bg-dark">
                <div class="modal-header border-bottom border-secondary">
                    <h5 class="modal-title text-white" id="imagePreviewModalLabel">Preview Gambar</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center p-0 position-relative" style="overflow: hidden; max-height: 80vh;">
                    <div id="imageContainer" class="d-flex justify-content-center align-items-center p-3" style="min-height: 300px;">
                        <img id="fullSizeImage" src="" alt="" class="img-fluid" style="max-width: 100%; max-height: 70vh; transition: transform 0.3s ease; transform-origin: center; cursor: move;">
                    </div>
                    <div class="image-controls position-absolute bottom-0 start-50 translate-middle-x pb-2 pt-2 px-3 bg-dark bg-opacity-75 rounded-pill" style="transition: opacity 0.3s ease; opacity: 0.7;">
                        <button id="zoomIn" class="btn btn-sm btn-outline-light rounded-circle"><i class="bi bi-zoom-in"></i></button>
                        <button id="zoomOut" class="btn btn-sm btn-outline-light rounded-circle mx-2"><i class="bi bi-zoom-out"></i></button>
                        <button id="resetZoom" class="btn btn-sm btn-outline-light rounded-circle"><i class="bi bi-arrows-fullscreen"></i></button>
                    </div>
                </div>
                <div class="modal-footer border-top border-secondary">
                    <span class="me-auto text-light small" id="imageInfo"></span>
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript for image preview -->
    <script>
        // Image Preview Modal
        let currentZoom = 1;
        const zoomStep = 0.25;
        let translateX = 0;
        let translateY = 0;
        let isDragging = false;
        let lastX, lastY;
        
        document.querySelectorAll('.item-image-preview').forEach(image => {
            image.addEventListener('click', function() {
                const imgSrc = this.getAttribute('data-img-src');
                const imgName = this.getAttribute('data-img-name');
                const fullSizeImage = document.getElementById('fullSizeImage');
                
                // Reset zoom and position for new image
                currentZoom = 1;
                translateX = 0;
                translateY = 0;
                fullSizeImage.style.transform = `scale(${currentZoom}) translate(${translateX}px, ${translateY}px)`;
                
                // Set the image source and update modal title
                fullSizeImage.src = imgSrc;
                fullSizeImage.alt = imgName;
                document.getElementById('imagePreviewModalLabel').textContent = 'Preview Gambar: ' + imgName;
                
                // Show loading state and handle image load
                fullSizeImage.style.opacity = '0.5';
                fullSizeImage.onload = function() {
                    fullSizeImage.style.opacity = '1';
                    document.getElementById('imageInfo').textContent = imgName + ' (' + this.naturalWidth + ' × ' + this.naturalHeight + 'px)';
                };
            });
        });
        
        // Image zoom controls
        document.getElementById('zoomIn').addEventListener('click', function() {
            if (currentZoom < 3) {
                currentZoom += zoomStep;
                document.getElementById('fullSizeImage').style.transform = `scale(${currentZoom}) translate(${translateX}px, ${translateY}px)`;
            }
        });
        
        document.getElementById('zoomOut').addEventListener('click', function() {
            if (currentZoom > 0.5) {
                currentZoom -= zoomStep;
                document.getElementById('fullSizeImage').style.transform = `scale(${currentZoom}) translate(${translateX}px, ${translateY}px)`;
            }
        });
        
        document.getElementById('resetZoom').addEventListener('click', function() {
            currentZoom = 1;
            translateX = 0;
            translateY = 0;
            document.getElementById('fullSizeImage').style.transform = `scale(${currentZoom}) translate(${translateX}px, ${translateY}px)`;
        });
        
        // Image dragging functionality
        const fullSizeImage = document.getElementById('fullSizeImage');
        fullSizeImage.addEventListener('mousedown', function(e) {
            if (currentZoom > 1) {
                isDragging = true;
                lastX = e.clientX;
                lastY = e.clientY;
                this.style.cursor = 'grabbing';
            }
        });
        
        document.addEventListener('mousemove', function(e) {
            if (isDragging && currentZoom > 1) {
                const deltaX = e.clientX - lastX;
                const deltaY = e.clientY - lastY;
                translateX += deltaX / currentZoom;
                translateY += deltaY / currentZoom;
                fullSizeImage.style.transform = `scale(${currentZoom}) translate(${translateX}px, ${translateY}px)`;
                lastX = e.clientX;
                lastY = e.clientY;
            }
        });
        
        document.addEventListener('mouseup', function() {
            isDragging = false;
            fullSizeImage.style.cursor = 'move';
        });
        
        // Reset on modal close
        document.getElementById('imagePreviewModal').addEventListener('hidden.bs.modal', function() {
            currentZoom = 1;
            translateX = 0;
            translateY = 0;
        });
        
        // Hover effect for image controls
        document.querySelector('.image-controls').addEventListener('mouseenter', function() {
            this.style.opacity = '1';
        });
        
        document.querySelector('.image-controls').addEventListener('mouseleave', function() {
            this.style.opacity = '0.7';
        });
    </script>
</body>
</html>
