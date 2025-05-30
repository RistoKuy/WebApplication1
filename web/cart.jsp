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
    if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("action") == null) {
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

    // Handle update quantity or delete item
    if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("action") != null) {
        String action = request.getParameter("action");
        String id_brg = request.getParameter("id_brg");
        if (action.equals("update")) {
            int newQty = Integer.parseInt(request.getParameter("new_qty"));
            for (Iterator<Map<String, Object>> it = cart.iterator(); it.hasNext();) {
                Map<String, Object> item = it.next();
                if (item.get("id_brg").equals(id_brg)) {
                    if (newQty > 0) {
                        item.put("jumlah", newQty);
                    } else {
                        it.remove();
                    }
                    break;
                }
            }
        } else if (action.equals("delete")) {
            for (Iterator<Map<String, Object>> it = cart.iterator(); it.hasNext();) {
                Map<String, Object> item = it.next();
                if (item.get("id_brg").equals(id_brg)) {
                    it.remove();
                    break;
                }
            }
        }
        sess.setAttribute("cart", cart);
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
                    <th>Aksi</th>
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
                    <td><img src="uploads/<%= gambar %>" alt="<%= nama %>" style="max-width:60px;max-height:60px;object-fit:contain;background:#222;cursor:pointer;" class="cart-image-preview" data-img="<%= gambar %>" data-nama="<%= nama %>"></td>
                    <td><%= nama %></td>
                    <td>Rp <%= String.format("%,d", harga).replace(',', '.') %></td>
                    <td>
                        <form method="post" action="cart.jsp" class="d-inline-flex align-items-center">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id_brg" value="<%= item.get("id_brg") %>" />
                            <input type="number" name="new_qty" value="<%= jumlah %>" min="1" max="<%= item.get("stok") %>" class="form-control form-control-sm me-2 cart-qty-input" style="width:70px;" data-id="<%= item.get("id_brg") %>" />
                        </form>
                    </td>
                    <td>Rp <%= String.format("%,d", total).replace(',', '.') %></td>
                    <td>
                        <form method="post" action="cart.jsp" style="display:inline;">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="id_brg" value="<%= item.get("id_brg") %>" />
                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Hapus <%= nama %> dari keranjang?')"><i class="bi bi-trash"></i></button>
                        </form>
                    </td>
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
        <a href="checkout.jsp" class="btn btn-success ms-2"><i class="bi bi-credit-card"></i> Checkout</a>
        <% } %>
    </div>
    <!-- Image Preview Modal -->
    <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-labelledby="imagePreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content bg-dark">
                <div class="modal-header border-0">
                    <h5 class="modal-title text-white" id="imagePreviewModalLabel">Preview Gambar</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-flex justify-content-center align-items-center" style="min-height:400px;">
                    <img id="fullSizeImage" src="" alt="Preview" style="max-width:90vw;max-height:70vh;border-radius:8px;box-shadow:0 4px 24px #000;transition:transform 0.2s;">
                </div>
            </div>
        </div>
    </div>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script>
    // Auto-submit quantity change
    const qtyInputs = document.querySelectorAll('.cart-qty-input');
    qtyInputs.forEach(function(input) {
        input.addEventListener('change', function() {
            if (parseInt(this.value) > 0) {
                this.form.submit();
            }
        });
    });

    // Image preview logic (like item_list.jsp)
    document.querySelectorAll('.cart-image-preview').forEach(img => {
        img.addEventListener('click', function() {
            const src = this.getAttribute('src');
            const nama = this.getAttribute('data-nama') || '';
            const modal = new bootstrap.Modal(document.getElementById('imagePreviewModal'));
            const fullSizeImage = document.getElementById('fullSizeImage');
            fullSizeImage.src = src;
            fullSizeImage.alt = nama;
            document.getElementById('imagePreviewModalLabel').textContent = nama;
            modal.show();
        });
    });
    </script>
</body>
</html>
