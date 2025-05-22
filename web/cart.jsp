<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%-- Cart Backend: Add item to cart and show cart contents --%>
<%
    // Cart is stored as a List of Map<String, Object> in session
    HttpSession sess = request.getSession();
    List<Map<String, Object>> cart = (List<Map<String, Object>>) sess.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
        sess.setAttribute("cart", cart);
    }

    // Handle add-to-cart POST
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String id_brg = request.getParameter("id_brg");
        String nama_brg = request.getParameter("nama_brg");
        String harga = request.getParameter("harga");
        String gambar_brg = request.getParameter("gambar_brg");
        String stok = request.getParameter("stok");
        boolean found = false;
        for (Map<String, Object> item : cart) {
            if (item.get("id_brg").equals(id_brg)) {
                int jumlah = (int) item.get("jumlah");
                item.put("jumlah", jumlah + 1);
                found = true;
                break;
            }
        }
        if (!found) {
            Map<String, Object> newItem = new HashMap<>();
            newItem.put("id_brg", id_brg);
            newItem.put("nama_brg", nama_brg);
            newItem.put("harga", harga);
            newItem.put("gambar_brg", gambar_brg);
            newItem.put("stok", stok);
            newItem.put("jumlah", 1);
            cart.add(newItem);
        }
        sess.setAttribute("cart", cart);
        // Show success message and redirect back to main.jsp if coming from there
        String from = request.getParameter("from");
        if (from != null && from.equals("main.jsp")) {
            session.setAttribute("cartSuccess", "Berhasil menambahkan <b>" + nama_brg + "</b> ke keranjang!");
            response.sendRedirect("main.jsp");
            return;
        }
        response.sendRedirect("cart.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Keranjang Belanja</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="bg-dark text-white">
    <div class="container py-5">
        <h2 class="mb-4"><i class="bi bi-cart4 me-2"></i>Keranjang Belanja</h2>
        <% if (cart.isEmpty()) { %>
            <div class="alert alert-info">Keranjang belanja kosong.</div>
        <% } else { %>
        <table class="table table-dark table-striped align-middle">
            <thead>
                <tr>
                    <th>Gambar</th>
                    <th>Nama Barang</th>
                    <th>Harga</th>
                    <th>Jumlah</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <% int grandTotal = 0;
                   for (Map<String, Object> item : cart) {
                       String gambar = (String) item.get("gambar_brg");
                       String nama = (String) item.get("nama_brg");
                       int harga = Integer.parseInt((String) item.get("harga"));
                       int jumlah = (int) item.get("jumlah");
                       int total = harga * jumlah;
                       grandTotal += total;
                %>
                <tr>
                    <td><img src="assets/img/<%= gambar %>" alt="<%= nama %>" style="max-width:60px;max-height:60px;object-fit:contain;background:#222;"></td>
                    <td><%= nama %></td>
                    <td>Rp <%= String.format("%,d", harga).replace(',', '.') %></td>
                    <td><%= jumlah %></td>
                    <td>Rp <%= String.format("%,d", total).replace(',', '.') %></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4" class="text-end">Grand Total</th>
                    <th>Rp <%= String.format("%,d", grandTotal).replace(',', '.') %></th>
                </tr>
            </tfoot>
        </table>
        <a href="main.jsp" class="btn btn-primary"><i class="bi bi-arrow-left"></i> Lanjut Belanja</a>
        <% } %>
    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
