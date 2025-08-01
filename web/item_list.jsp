<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Item | Aplikasi JSP</title>
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
            font-weight: bold;
        }
        
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
            background-color: rgba(187, 134, 252, 0.2);        }
        
        .sidebar-menu li.active a {
            color: var(--accent-purple);
        }
          /* Image preview styling */
        .item-image-preview {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border-radius: 4px;
            border: 2px solid transparent;
        }
        
        .item-image-preview:hover {
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(187, 134, 252, 0.6);
            border-color: var(--accent-purple);
        }
        
        #imageContainer {
            overflow: hidden;
            position: relative;
        }
        
        #fullSizeImage {
            transform-origin: center;
            cursor: move;
        }
        
        .image-controls {
            transition: opacity 0.3s ease;
            opacity: 0.7;
            z-index: 1050;
        }
        
        .image-controls:hover {
            opacity: 1;
        }
        
        /* Main content styling */
        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 200px;
            background-color: transparent;
            position: relative;
            z-index: 5;
        }
        
        .data-table {
            background-color: rgba(30, 30, 30, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            color: var(--text-primary);
        }
        
        .data-table:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(187, 134, 252, 0.2) !important;
            border-color: var(--accent-purple);
        }
        
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
        
        .btn-add {
            background-color: var(--accent-blue);
            color: #121212;
            border: none;
            border-radius: 8px;
            padding: 8px 20px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            margin-left: 10px;
        }
        
        .btn-add:hover {
            background-color: #018786;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(3, 218, 198, 0.3);
        }
        
        .btn-export-docx {
            background-color: #4285f4;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 20px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            margin-left: 10px;
        }
        
        .btn-export-docx:hover {
            background-color: #3367d6;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(66, 133, 244, 0.3);
            color: white;
        }
        
        .btn-export-excel {
            background-color: #34a853;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 20px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            margin-left: 10px;
        }
        
        .btn-export-excel:hover {
            background-color: #2d7a3d;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 168, 83, 0.3);
            color: white;
        }
        
        /* Modal styling */
        .modal-content {
            background-color: #1e1e1e;
            color: #e1e1e1;
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .modal-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .modal-footer {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .form-control {
            background-color: #2d2d2d;
            color: #e1e1e1;
            border: 1px solid #444;
            border-radius: 8px;
        }
        
        .form-control:focus {
            background-color: #333;
            border-color: var(--accent-purple);
            color: #e1e1e1;
            box-shadow: 0 0 0 0.25rem rgba(187, 134, 252, 0.25);
        }
        
        .btn-save {
            background-color: var(--accent-purple);
            color: #121212;
            border: none;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-save:hover {
            background-color: #9546fa;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
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
            border-radius: 5px;
        }
        
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
    
    <%
        // Check if user is logged in
        Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
        if (isLoggedIn == null || !isLoggedIn) {
            // Redirect to login page if not logged in
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userName = (String) session.getAttribute("userName");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Load the database driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to the database
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String dbUser = "root";
            String dbPassword = "";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
            
            // We'll use prepared statement instead of regular statement
            // for better security and flexibility
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
    
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h5><i class="bi bi-code-square me-2"></i>Dashboard</h5>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp"><i class="bi bi-house me-2"></i>Home</a></li>
            <li><a href="account_list.jsp"><i class="bi bi-person-lines-fill me-2"></i>User</a></li>
            <li class="active"><a href="item_list.jsp"><i class="bi bi-box-seam me-2"></i>Item</a></li>
            <li><a href="admin_orders.jsp"><i class="bi bi-receipt me-2"></i>Orders</a></li>
            <li><a href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="data-table">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0 neon-text">Item Management</h2>
                <div class="d-flex">
                    <a href="export_items_docx.jsp" class="btn btn-export-docx" onclick="showExportLoading(this, 'Word (.docx)')">
                        <i class="bi bi-file-earmark-word me-2"></i>Export to Word (.docx)
                    </a>
                    <a href="export_items_excel.jsp" class="btn btn-export-excel" onclick="showExportLoading(this, 'Excel (.xlsx)')">
                        <i class="bi bi-file-earmark-spreadsheet me-2"></i>Export to Excel (.xlsx)
                    </a>
                    <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addItemModal">
                        <i class="bi bi-plus-circle me-2"></i>Add New Item
                    </button>
                </div>
            </div>
            
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill me-2"></i><%= request.getParameter("success") %>
                </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getParameter("error") %>
                </div>
            <% } %>
            
            <table class="table table-striped">                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Stock</th>
                        <th>Price</th>
                        <th>Image</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        try {
                            String sql = "SELECT * FROM item ORDER BY id_brg";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                              while(rs.next()) {
                                int id_brg = rs.getInt("id_brg");
                                String nama_brg = rs.getString("nama_brg");
                                String deskripsi = rs.getString("deskripsi");
                                String harga = rs.getString("harga");
                                int stok = rs.getInt("stok");
                                String gambar_brg = rs.getString("gambar_brg");
                                // Format harga ke format "Rp 100.000"
                                String hargaFormatted = "Rp " + String.format("%,d", Integer.parseInt(harga)).replace(',', '.');
                    %>
                    <tr>
                        <td><%= nama_brg %></td>
                        <td><%= stok %></td>
                        <td><%= hargaFormatted %></td>
                        <td>                            <% if(gambar_brg != null && !gambar_brg.isEmpty()) { %>
                                <img src="uploads/<%= gambar_brg %>" alt="<%= nama_brg %>" height="60" 
                                    class="item-image-preview" data-bs-toggle="modal" data-bs-target="#imagePreviewModal"
                                    data-img-src="uploads/<%= gambar_brg %>" data-img-name="<%= nama_brg %>"
                                    style="cursor: pointer;">
                            <% } else { %>
                                <span class="text-muted">No image</span>
                            <% } %>
                        </td>
                        <td>
                            <button class="btn btn-edit" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#editItemModal"
                                    data-id="<%= id_brg %>"
                                    data-nama="<%= nama_brg %>"
                                    data-deskripsi="<%= deskripsi %>"
                                    data-harga="<%= harga %>"
                                    data-stok="<%= stok %>"
                                    data-gambar="<%= gambar_brg %>">
                                <i class="bi bi-pencil-square me-1"></i>Edit
                            </button>
                            <button class="btn btn-delete" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#deleteItemModal"
                                    data-id="<%= id_brg %>"
                                    data-nama="<%= nama_brg %>">
                                <i class="bi bi-trash me-1"></i>Delete
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                            
                            // If no records found, display message
                            if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                    %>                    <tr>
                        <td colspan="5" class="text-center">No items found</td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='text-center'>Error displaying data: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Add Item Modal -->
    <div class="modal fade" id="addItemModal" tabindex="-1" aria-labelledby="addItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addItemModalLabel">Add New Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>                <form action="admin_add_item.jsp" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="add-nama" class="form-label">Nama Barang</label>
                            <input type="text" class="form-control" id="add-nama" name="nama_brg" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-deskripsi" class="form-label">Deskripsi</label>
                            <textarea class="form-control" id="add-deskripsi" name="deskripsi" rows="2"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="add-harga" class="form-label">Harga</label>
                            <input type="number" class="form-control" id="add-harga" name="harga" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-stok" class="form-label">Stok</label>
                            <input type="number" class="form-control" id="add-stok" name="stok" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-gambar" class="form-label">Gambar</label>
                            <input class="form-control" type="file" id="add-gambar" name="gambar_file" accept="image/*">
                            <img id="add-preview-img" src="#" alt="Preview" class="img-fluid mt-2 d-none" style="max-height:150px;" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-save">Add Item</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Item Modal -->
    <div class="modal fade" id="editItemModal" tabindex="-1" aria-labelledby="editItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editItemModalLabel">Edit Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>                <form action="admin_update_item.jsp" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="edit-id" name="id_brg">
                        <input type="hidden" id="edit-current-gambar" name="current_gambar">
                        <div class="mb-3">
                            <label for="edit-nama" class="form-label">Nama Barang</label>
                            <input type="text" class="form-control" id="edit-nama" name="nama_brg" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-deskripsi" class="form-label">Deskripsi</label>
                            <textarea class="form-control" id="edit-deskripsi" name="deskripsi" rows="2"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="edit-harga" class="form-label">Harga</label>
                            <input type="number" class="form-control" id="edit-harga" name="harga" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-stok" class="form-label">Stok</label>
                            <input type="number" class="form-control" id="edit-stok" name="stok" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-gambar" class="form-label">Gambar</label>
                            <input class="form-control" type="file" id="edit-gambar" name="gambar_file" accept="image/*">
                            <img id="edit-preview-img" src="#" alt="Preview" class="img-fluid mt-2 d-none" style="max-height:150px;" />
                            <div id="edit-current-image-container" class="mt-2"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-save">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete Item Modal -->
    <div class="modal fade" id="deleteItemModal" tabindex="-1" aria-labelledby="deleteItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteItemModalLabel">Delete Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_delete_item.jsp" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="delete-id" name="id_brg">
                        <p>Are you sure you want to delete the item <strong><span id="delete-item-name"></span></strong>?</p>
                        <p class="text-danger">This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete Item</button>
                    </div>
                </form>
            </div>
        </div>    </div>
      <!-- Image Preview Modal -->
    <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-labelledby="imagePreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content bg-dark">
                <div class="modal-header border-bottom border-secondary">
                    <h5 class="modal-title" id="imagePreviewModalLabel">Image Preview</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center p-0 position-relative" style="overflow: hidden; max-height: 80vh;">
                    <div id="imageContainer" class="d-flex justify-content-center align-items-center p-3" style="min-height: 300px;">
                        <img id="fullSizeImage" src="" alt="" class="img-fluid" style="max-width: 100%; max-height: 70vh; transition: transform 0.3s ease;">
                    </div>
                    <div class="image-controls position-absolute bottom-0 start-50 translate-middle-x pb-2 pt-2 px-3 bg-dark bg-opacity-75 rounded-pill">
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
    
    <!-- Bootstrap JS -->
    <script src="js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript for modals -->
    <script>
        // Edit item modal data
        document.querySelectorAll('.btn-edit').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const nama = this.getAttribute('data-nama');
                const deskripsi = this.getAttribute('data-deskripsi');
                const harga = this.getAttribute('data-harga');
                const stok = this.getAttribute('data-stok');
                const gambar = this.getAttribute('data-gambar');
                document.getElementById('edit-id').value = id;
                document.getElementById('edit-nama').value = nama;
                document.getElementById('edit-deskripsi').value = deskripsi;
                document.getElementById('edit-harga').value = harga;
                document.getElementById('edit-stok').value = stok;
                document.getElementById('edit-current-gambar').value = gambar;
                
                // Show current image preview if available
                const imageContainer = document.getElementById('edit-current-image-container');
                imageContainer.innerHTML = '';                if (gambar && gambar.trim() !== '') {
                    const img = document.createElement('img');
                    img.src = 'uploads/' + gambar;
                    img.alt = nama;
                    img.style.maxHeight = '100px';
                    img.style.marginBottom = '10px';
                    imageContainer.appendChild(img);
                    imageContainer.appendChild(document.createElement('br'));
                    const label = document.createElement('span');
                    label.textContent = 'Current image: ' + gambar;
                    label.classList.add('text-muted');
                    imageContainer.appendChild(label);
                } else {
                    const label = document.createElement('span');
                    label.textContent = 'No current image';
                    label.classList.add('text-muted');
                    imageContainer.appendChild(label);
                }
            });
        });
        
        // Delete item modal data
        document.querySelectorAll('.btn-delete').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const nama = this.getAttribute('data-nama');
                document.getElementById('delete-id').value = id;
                document.getElementById('delete-item-name').textContent = nama;
            });
        });
        
        // Image Preview for Add Item form
        const addGambarInput = document.getElementById('add-gambar');
        const addPreviewImg = document.getElementById('add-preview-img');
        if (addGambarInput) {
            addGambarInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(ev) {
                        addPreviewImg.src = ev.target.result;
                        addPreviewImg.classList.remove('d-none');
                    };
                    reader.readAsDataURL(file);
                } else {
                    addPreviewImg.src = '#';
                    addPreviewImg.classList.add('d-none');
                }
            });
        }
        // Image Preview for Edit Item form
        const editGambarInput = document.getElementById('edit-gambar');
        const editPreviewImg = document.getElementById('edit-preview-img');
        if (editGambarInput) {
            editGambarInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(ev) {
                        editPreviewImg.src = ev.target.result;
                        editPreviewImg.classList.remove('d-none');
                    };
                    reader.readAsDataURL(file);
                } else {
                    editPreviewImg.src = '#';
                    editPreviewImg.classList.add('d-none');
                }
            });
        }
        // When opening edit modal, show current image if exists
        function showEditCurrentImage(gambar) {
            const container = document.getElementById('edit-current-image-container');
            container.innerHTML = '';            if (gambar && gambar.trim() !== '') {
                const img = document.createElement('img');
                img.src = 'uploads/' + gambar;
                img.alt = 'Current Image';
                img.className = 'img-fluid mt-2';
                img.style.maxHeight = '100px';
                container.appendChild(img);
            }
        }
        // Patch edit modal open logic to show current image
        // (Assumes you have logic to set data-gambar on edit buttons)
        document.querySelectorAll('.btn-edit').forEach(button => {
            button.addEventListener('click', function() {
                const gambar = this.getAttribute('data-gambar');
                showEditCurrentImage(gambar);
                editPreviewImg.src = '#';
                editPreviewImg.classList.add('d-none');
            });
        });
        
        // Image Preview Modal
        let currentZoom = 1;
        const zoomStep = 0.25;
        
        document.querySelectorAll('.item-image-preview').forEach(image => {
            image.addEventListener('click', function() {
                const imgSrc = this.getAttribute('data-img-src');
                const imgName = this.getAttribute('data-img-name');
                const fullSizeImage = document.getElementById('fullSizeImage');
                
                // Reset zoom for new image
                currentZoom = 1;
                fullSizeImage.style.transform = 'scale(' + currentZoom + ')';
                
                // Set the image source and update modal title
                fullSizeImage.src = imgSrc;
                fullSizeImage.alt = imgName;
                document.getElementById('imagePreviewModalLabel').textContent = 'Image Preview: ' + imgName;
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
                document.getElementById('fullSizeImage').style.transform = 'scale(' + currentZoom + ')';
            }
        });
        
        document.getElementById('zoomOut').addEventListener('click', function() {
            if (currentZoom > 0.5) {
                currentZoom -= zoomStep;
                document.getElementById('fullSizeImage').style.transform = 'scale(' + currentZoom + ')';
            }
        });
        
        document.getElementById('resetZoom').addEventListener('click', function() {
            currentZoom = 1;
            document.getElementById('fullSizeImage').style.transform = 'scale(1)';
        });
          // Add keyboard controls
        document.addEventListener('keydown', function(e) {
            const modal = document.getElementById('imagePreviewModal');
            if (modal.classList.contains('show')) {
                if (e.key === '+' || e.key === '=') {
                    document.getElementById('zoomIn').click();
                } else if (e.key === '-' || e.key === '_') {
                    document.getElementById('zoomOut').click();
                } else if (e.key === '0') {
                    document.getElementById('resetZoom').click();
                } else if (e.key === 'Escape') {
                    modal.querySelector('.btn-close').click();
                }
            }
        });
        
        // Image dragging functionality when zoomed
        const fullSizeImage = document.getElementById('fullSizeImage');
        let isDragging = false;
        let startX, startY, translateX = 0, translateY = 0;
        
        fullSizeImage.addEventListener('mousedown', function(e) {
            if (currentZoom > 1) {
                isDragging = true;
                startX = e.clientX - translateX;
                startY = e.clientY - translateY;
                this.style.cursor = 'grabbing';
                e.preventDefault();
            }
        });
        
        document.addEventListener('mousemove', function(e) {
            if (isDragging && currentZoom > 1) {
                translateX = e.clientX - startX;
                translateY = e.clientY - startY;
                fullSizeImage.style.transform = 'scale(' + currentZoom + ') translate(' + (translateX/currentZoom) + 'px, ' + (translateY/currentZoom) + 'px)';
            }
        });
        
        document.addEventListener('mouseup', function() {
            if (isDragging) {
                isDragging = false;
                fullSizeImage.style.cursor = 'move';
            }
        });
        
        // Reset position when zoom is reset
        document.getElementById('resetZoom').addEventListener('click', function() {
            translateX = 0;
            translateY = 0;
        });
        
        // Reset position on new image
        document.getElementById('imagePreviewModal').addEventListener('hidden.bs.modal', function() {
            translateX = 0;
            translateY = 0;
        });
        
        // Export loading function
        function showExportLoading(button, format) {
            const originalContent = button.innerHTML;
            button.innerHTML = '<i class="bi bi-arrow-clockwise me-2" style="animation: spin 1s linear infinite;"></i>Exporting ' + format + '...';
            button.style.pointerEvents = 'none';
            
            // Reset button after 3 seconds
            setTimeout(function() {
                button.innerHTML = originalContent;
                button.style.pointerEvents = 'auto';
                
                // Show success notification
                showNotification('Export completed! Check your downloads folder for the ' + format + ' file.', 'success');
            }, 3000);
        }
        
        // Notification function
        function showNotification(message, type) {
            // Create notification element
            const notification = document.createElement('div');
            notification.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed';
            notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px; box-shadow: 0 4px 12px rgba(0,0,0,0.3);';
            
            // Determine icon based on type
            const icon = (type === 'success') ? 'check-circle-fill' : 'exclamation-triangle-fill';
            
            notification.innerHTML = 
                '<i class="bi bi-' + icon + ' me-2"></i>' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
            
            // Add to body
            document.body.appendChild(notification);
            
            // Auto remove after 5 seconds
            setTimeout(function() {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 5000);
        }
    </script>
    
    <style>
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    
    <%
        // Close the database resources
        try {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException e) {
            // Do nothing
        }
    %>
</body>
</html>