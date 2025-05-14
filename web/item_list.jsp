<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Item Management | Aplikasi JSP</title>
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
            background-color: rgba(187, 134, 252, 0.2);
        }
        
        .sidebar-menu li.active a {
            color: var(--accent-purple);
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
        }
        
        .btn-add:hover {
            background-color: #018786;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(3, 218, 198, 0.3);
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
            <li><a href="account_list.jsp"><i class="bi bi-person-lines-fill me-2"></i>User Management</a></li>
            <li class="active"><a href="item_list.jsp"><i class="bi bi-box-seam me-2"></i>Item Management</a></li>
            <li><a href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="data-table">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0 neon-text">Item Management</h2>
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addItemModal">
                    <i class="bi bi-plus-circle me-2"></i>Add New Item
                </button>
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
                        <th>ID</th>
                        <th>Item Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Stock</th>
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
                                int id = rs.getInt("id_brg");
                                String nama_brg = rs.getString("nama_brg");
                                String deskripsi = rs.getString("deskripsi");
                                String harga = rs.getString("harga");
                                int stok = rs.getInt("stok");
                                String gambar_brg = rs.getString("gambar_brg");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= nama_brg %></td>
                        <td><%= deskripsi %></td>
                        <td><%= harga %></td>
                        <td><%= stok %></td>
                        <td>
                            <% if(gambar_brg != null && !gambar_brg.isEmpty()) { %>
                                <img src="assets/img/<%= gambar_brg %>" alt="<%= nama_brg %>" height="60">
                            <% } else { %>
                                <span class="text-muted">No image</span>
                            <% } %>
                        </td>
                        <td>
                            <button class="btn btn-edit" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#editItemModal"
                                    data-id="<%= id %>"
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
                                    data-id="<%= id %>"
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
                        <td colspan="7" class="text-center">No items found</td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7' class='text-center'>Error displaying data: " + e.getMessage() + "</td></tr>");
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
                            <label for="add-nama" class="form-label">Item Name</label>
                            <input type="text" class="form-control" id="add-nama" name="nama_brg" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-deskripsi" class="form-label">Description</label>
                            <textarea class="form-control" id="add-deskripsi" name="deskripsi" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="add-harga" class="form-label">Price</label>
                            <input type="text" class="form-control" id="add-harga" name="harga" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-stok" class="form-label">Stock</label>
                            <input type="number" class="form-control" id="add-stok" name="stok" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-gambar" class="form-label">Image</label>
                            <input type="file" class="form-control" id="add-gambar" name="gambar_file" accept="image/*">
                            <div class="form-text">Select an image file (JPG, PNG, GIF)</div>
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
                            <label for="edit-nama" class="form-label">Item Name</label>
                            <input type="text" class="form-control" id="edit-nama" name="nama_brg" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-deskripsi" class="form-label">Description</label>
                            <textarea class="form-control" id="edit-deskripsi" name="deskripsi" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="edit-harga" class="form-label">Price</label>
                            <input type="text" class="form-control" id="edit-harga" name="harga" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-stok" class="form-label">Stock</label>
                            <input type="number" class="form-control" id="edit-stok" name="stok" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-gambar" class="form-label">Image</label>
                            <div id="edit-current-image-container" class="mb-2"></div>
                            <input type="file" class="form-control" id="edit-gambar" name="gambar_file" accept="image/*">
                            <div class="form-text">Select a new image file or leave blank to keep current image</div>
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
                imageContainer.innerHTML = '';
                if (gambar && gambar.trim() !== '') {
                    const img = document.createElement('img');
                    img.src = 'assets/img/' + gambar;
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
        document.getElementById('add-gambar').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    // Create image preview element if it doesn't exist
                    let previewContainer = document.getElementById('add-image-preview');
                    if (!previewContainer) {
                        previewContainer = document.createElement('div');
                        previewContainer.id = 'add-image-preview';
                        previewContainer.className = 'mt-2';
                        e.target.parentNode.appendChild(previewContainer);
                    }
                    
                    // Set the preview
                    previewContainer.innerHTML = `
                        <p>Preview:</p>
                        <img src="${event.target.result}" alt="Image Preview" style="max-height: 150px; max-width: 100%;" class="mt-2 mb-2 border rounded">
                        <p class="text-muted small">Filename: ${file.name}</p>
                    `;
                };
                reader.readAsDataURL(file);
            }
        });
        
        // Image Preview for Edit Item form
        document.getElementById('edit-gambar').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    // Create image preview element if it doesn't exist
                    let previewContainer = document.getElementById('edit-image-preview');
                    if (!previewContainer) {
                        previewContainer = document.createElement('div');
                        previewContainer.id = 'edit-image-preview';
                        previewContainer.className = 'mt-2';
                        e.target.parentNode.appendChild(previewContainer);
                    }
                    
                    // Set the preview
                    previewContainer.innerHTML = `
                        <p>New image preview:</p>
                        <img src="${event.target.result}" alt="Image Preview" style="max-height: 150px; max-width: 100%;" class="mt-2 mb-2 border rounded">
                        <p class="text-muted small">Filename: ${file.name}</p>
                    `;
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
    
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