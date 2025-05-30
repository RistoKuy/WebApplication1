<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%-- User Order History Page --%>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
      // Get firebase_uid from session (set during login)
    String firebase_uid = (String) session.getAttribute("firebase_uid");
    String error = null;
    
    // Fallback mechanism for firebase_uid
    if (firebase_uid == null || firebase_uid.isEmpty()) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail != null && !userEmail.isEmpty()) {
            // Use email as temporary identifier until Firebase UID is properly set
            firebase_uid = "email:" + userEmail;
            session.setAttribute("firebase_uid", firebase_uid);
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Pesanan Saya</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">    <div class="container py-5">
        <h2 class="mb-4">Pesanan Saya</h2>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } else if (firebase_uid == null) { %>
            <div class="alert alert-warning">Tidak dapat memuat pesanan: Firebase UID tidak ditemukan. Silakan login ulang.</div>
        <% } else { %>
        <table class="table table-dark table-striped">
            <thead>
                <tr>
                    <th>Tanggal</th>
                    <th>Nama Barang</th>
                    <th>Jumlah</th>
                    <th>Harga</th>
                    <th>Metode</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/web_enterprise";
                    String dbUser = "root";
                    String dbPassword = "";
                    Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);
                    String sql = "SELECT * FROM `order` WHERE firebase_uid = ? ORDER BY tgl_order DESC";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, firebase_uid);
                    ResultSet rs = pstmt.executeQuery();
                    boolean hasOrder = false;
                    while (rs.next()) {
                        hasOrder = true;
                %>                <tr>
                    <td><%= rs.getTimestamp("tgl_order") %></td>
                    <td><%= rs.getString("nama_brg") %></td>
                    <td><%= rs.getInt("jumlah") %></td>
                    <td>Rp <%= String.format("%,d", Integer.parseInt(rs.getString("harga"))).replace(',', '.') %></td>
                    <td><%= rs.getString("metode_pembayaran") %></td>
                    <td>
                        <% String orderStatus = rs.getString("status_order");
                           if ("pending".equals(orderStatus)) { %>
                            <span class="badge bg-warning text-dark">Pending</span>
                        <% } else if ("completed".equals(orderStatus)) { %>
                            <span class="badge bg-success">Completed</span>
                        <% } else { %>
                            <span class="badge bg-secondary"><%= orderStatus %></span>
                        <% } %>
                    </td>
                </tr>
                <% }
                    if (!hasOrder) { %>
                    <tr><td colspan="6" class="text-center">Belum ada pesanan.</td></tr>
                <% }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch(Exception e) { %>
                    <tr><td colspan="6" class="text-danger">Gagal mengambil data pesanan: <%= e.getMessage() %></td></tr>
                <% } %>            </tbody>
        </table>
        <% } %>
        <a href="main.jsp" class="btn btn-primary">Kembali ke Toko</a>
    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
