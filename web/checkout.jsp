<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="java.sql.*"%>
<%-- Checkout Page --%>
<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Get cart from session
    HttpSession sess = request.getSession();
    List<Map<String, Object>> cart = (List<Map<String, Object>>) sess.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    
    // Get firebase_uid from session (set during login)
    String firebase_uid = (String) session.getAttribute("firebase_uid");
    String error = null;
    String success = null;if (request.getMethod().equalsIgnoreCase("POST")) {
        String nama_penerima = request.getParameter("nama_penerima");
        String alamat = request.getParameter("alamat");
        String no_telp = request.getParameter("no_telp");
        String metode_pembayaran = request.getParameter("metode_pembayaran");
          // Validate form fields
        if (nama_penerima == null || alamat == null || no_telp == null || metode_pembayaran == null || 
            nama_penerima.isEmpty() || alamat.isEmpty() || no_telp.isEmpty()) {
            error = "Semua field harus diisi.";        } else if (firebase_uid == null || firebase_uid.isEmpty()) {
            // If firebase_uid is not in session, try to get it from user email
            // This is a fallback for older sessions or if login didn't properly set firebase_uid
            String userEmail = (String) session.getAttribute("userEmail");
            if (userEmail != null && !userEmail.isEmpty()) {
                // Use email as temporary identifier until Firebase UID is properly set
                firebase_uid = "email:" + userEmail;
                session.setAttribute("firebase_uid", firebase_uid);
            } else {
                error = "Gagal memproses pesanan: Tidak dapat menemukan identitas pengguna. Silakan login ulang.";
            }
        }
        
        if (error == null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/web_enterprise";
                String dbUser = "root";
                String dbPassword = "";
                Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);
                String sql = "INSERT INTO `order` (id_brg, firebase_uid, nama_brg, jumlah, harga, metode_pembayaran, nama_penerima, alamat, no_telp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";                PreparedStatement pstmt = conn.prepareStatement(sql);
                for (Map<String, Object> item : cart) {
                    pstmt.setInt(1, Integer.parseInt((String)item.get("id_brg")));
                    pstmt.setString(2, firebase_uid);
                    pstmt.setString(3, (String)item.get("nama_brg"));
                    pstmt.setInt(4, (int)item.get("jumlah"));
                    pstmt.setString(5, (String)item.get("harga"));
                    pstmt.setString(6, metode_pembayaran);
                    pstmt.setString(7, nama_penerima);
                    pstmt.setString(8, alamat);
                    pstmt.setString(9, no_telp);
                    pstmt.executeUpdate();

                    // Update stock in item table
                    String updateStockSql = "UPDATE item SET stok = stok - ? WHERE id_brg = ? AND stok >= ?";
                    try (PreparedStatement updateStockStmt = conn.prepareStatement(updateStockSql)) {
                        updateStockStmt.setInt(1, (int)item.get("jumlah"));
                        updateStockStmt.setInt(2, Integer.parseInt((String)item.get("id_brg")));
                        updateStockStmt.setInt(3, (int)item.get("jumlah"));
                        int affected = updateStockStmt.executeUpdate();
                        if (affected == 0) {
                            throw new Exception("Stok tidak cukup untuk barang: " + item.get("nama_brg"));
                        }
                    }
                }
                pstmt.close();
                conn.close();
                sess.setAttribute("cart", new ArrayList<>()); // Clear cart
                success = "Pesanan berhasil dibuat!";
                response.sendRedirect("user_orders.jsp");
                return;
            } catch(Exception e) {
                error = "Gagal memproses pesanan: " + e.getMessage();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
    <div class="container py-5">
        <h2 class="mb-4">Checkout</h2>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        <% if (success != null) { %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>
        <h4>Ringkasan Belanja</h4>
        <table class="table table-dark table-striped">
            <thead>
                <tr>
                    <th>Nama Barang</th>
                    <th>Harga</th>
                    <th>Jumlah</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <% int grandTotal = 0;
                   for (Map<String, Object> item : cart) {
                       int harga = Integer.parseInt((String)item.get("harga"));
                       int jumlah = (int)item.get("jumlah");
                       int total = harga * jumlah;
                       grandTotal += total;
                %>
                <tr>
                    <td><%= item.get("nama_brg") %></td>
                    <td>Rp <%= String.format("%,d", harga).replace(',', '.') %></td>
                    <td><%= jumlah %></td>
                    <td>Rp <%= String.format("%,d", total).replace(',', '.') %></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3" class="text-end">Grand Total</th>
                    <th>Rp <%= String.format("%,d", grandTotal).replace(',', '.') %></th>
                </tr>
            </tfoot>
        </table>
        <form method="post" class="mt-4">
            <div class="mb-3">
                <label for="nama_penerima" class="form-label">Nama Penerima</label>
                <input type="text" class="form-control" id="nama_penerima" name="nama_penerima" required />
            </div>
            <div class="mb-3">
                <label for="alamat" class="form-label">Alamat</label>
                <textarea class="form-control" id="alamat" name="alamat" rows="3" required></textarea>
            </div>
            <div class="mb-3">
                <label for="no_telp" class="form-label">No. Telepon</label>
                <input type="text" class="form-control" id="no_telp" name="no_telp" required />
            </div>
            <div class="mb-3">
                <label for="metode_pembayaran" class="form-label">Metode Pembayaran</label>
                <select class="form-select" id="metode_pembayaran" name="metode_pembayaran" required>
                    <option value="">Pilih Metode</option>
                    <option value="Debit/Kredit">Debit/Kredit</option>
                    <option value="QRIS">QRIS</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Order</button>
            <a href="cart.jsp" class="btn btn-secondary">Kembali ke Keranjang</a>
        </form>    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
