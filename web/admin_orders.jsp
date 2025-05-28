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
    <title>Manajemen Pesanan</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
    <div class="container py-5">
        <h2 class="mb-4">Manajemen Pesanan</h2>
        <table class="table table-dark table-striped">
            <thead>
                <tr>
                    <th>Tanggal</th>
                    <th>Nama Pembeli</th>
                    <th>Nama Barang</th>
                    <th>Jumlah</th>
                    <th>Harga</th>
                    <th>Metode</th>
                    <th>Status</th>
                    <th>Alamat</th>
                    <th>No. Telp</th>
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
                    String sql = "SELECT * FROM `order` ORDER BY tgl_order DESC";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    ResultSet rs = pstmt.executeQuery();
                    boolean hasOrder = false;
                    while (rs.next()) {
                        hasOrder = true;
                %>
                <tr>
                    <td><%= rs.getTimestamp("tgl_order") %></td>
                    <td><%= rs.getString("nama_penerima") %></td>
                    <td><%= rs.getString("nama_brg") %></td>
                    <td><%= rs.getInt("jumlah") %></td>
                    <td>Rp <%= String.format("%,d", Integer.parseInt(rs.getString("harga"))).replace(',', '.') %></td>
                    <td><%= rs.getString("metode_pembayaran") %></td>
                    <td><%= rs.getString("status_pembayaran") %></td>
                    <td><%= rs.getString("alamat") %></td>
                    <td><%= rs.getString("no_telp") %></td>
                </tr>
                <% }
                    if (!hasOrder) { %>
                    <tr><td colspan="9" class="text-center">Belum ada pesanan.</td></tr>
                <% }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch(Exception e) { %>
                    <tr><td colspan="9" class="text-danger">Gagal mengambil data pesanan: <%= e.getMessage() %></td></tr>
                <% } %>
            </tbody>
        </table>
        <a href="dashboard.jsp" class="btn btn-primary">Kembali ke Dashboard</a>
    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
