<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Admin Panel | User Management</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #121212;
            color: #e1e1e1;
            min-height: 100vh;
            padding-top: 80px;
        }
        .navbar {
            background-color: rgba(18, 18, 18, 0.9) !important;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .navbar-brand {
            color: #bb86fc !important;
            font-weight: bold;
        }
        .nav-link {
            color: #e1e1e1 !important;
        }
        .nav-link:hover, .nav-link.active {
            color: #bb86fc !important;
        }
        .table-container {
            background: #1e1e1e;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.5);
            padding: 30px;
            margin-bottom: 40px;
        }
        .table {
            color: #e1e1e1;
        }
        .table thead {
            background-color: #2d2d2d;
        }
        .btn-action {
            color: #e1e1e1;
            background-color: transparent;
            border: 1px solid #444;
            margin-right: 5px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-edit {
            border-color: #bb86fc;
            color: #bb86fc;
        }
        .btn-edit:hover {
            background-color: #bb86fc;
            color: #121212;
        }
        .btn-delete {
            border-color: #cf6679;
            color: #cf6679;
        }
        .btn-delete:hover {
            background-color: #cf6679;
            color: #121212;
        }
        .btn-add {
            background-color: #03dac6;
            color: #121212;
            border: none;
            transition: all 0.3s;
        }
        .btn-add:hover {
            background-color: #018786;
            box-shadow: 0 5px 15px rgba(3, 218, 198, 0.3);
        }
        .modal-content {
            background-color: #1e1e1e;
            color: #e1e1e1;
        }
        .modal-header {
            border-bottom: 1px solid #333;
        }
        .modal-footer {
            border-top: 1px solid #333;
        }
        .form-control {
            background-color: #2d2d2d;
            color: #e1e1e1;
            border: 1px solid #444;
            border-radius: 8px;
        }
        .form-control:focus {
            background-color: #333;
            border-color: #bb86fc;
            color: #e1e1e1;
        }
        .btn-save {
            background-color: #bb86fc;
            color: #121212;
            border: none;
        }
        .btn-save:hover {
            background-color: #9a67ea;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in (in a real app, you would check for admin role)
        Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
        if (isLoggedIn == null || !isLoggedIn) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Open a connection
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String dbUser = "root";
            String dbPassword = "";
            
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>Error connecting to database: " + e.getMessage() + "</div>");
        }
    %>
    
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="bi bi-shield-lock me-2"></i>Admin Panel</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="admin_panel.jsp">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Settings</a>
                    </li>
                </ul>
                <div>
                    <a href="index.jsp" class="btn btn-outline-light me-2">
                        <i class="bi bi-house-door"></i> Home
                    </a>
                    <a href="logout.jsp" class="btn btn-danger">
                        <i class="bi bi-box-arrow-right me-1"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="table-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="mb-0">User Management</h1>
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="bi bi-plus-circle me-2"></i>Add New User
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
            
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Get all users
                        try {
                            String sql = "SELECT * FROM user ORDER BY id";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("nama") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td>
                            <button class="btn btn-action btn-edit" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#editUserModal"
                                    data-id="<%= rs.getInt("id") %>"
                                    data-nama="<%= rs.getString("nama") %>"
                                    data-email="<%= rs.getString("email") %>"
                                    data-password="<%= rs.getString("password") %>">
                                <i class="bi bi-pencil-square"></i>
                            </button>
                            <button class="btn btn-action btn-delete" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#deleteUserModal"
                                    data-id="<%= rs.getInt("id") %>"
                                    data-nama="<%= rs.getString("nama") %>">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch(Exception e) {
                            out.println("<tr><td colspan='4' class='text-center text-danger'>Error retrieving users: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_add_user.jsp" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="add-nama" class="form-label">Name</label>
                            <input type="text" class="form-control" id="add-nama" name="nama" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="add-email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="add-password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="add-password" name="password" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-save">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_update_user.jsp" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="edit-id" name="id">
                        <div class="mb-3">
                            <label for="edit-nama" class="form-label">Name</label>
                            <input type="text" class="form-control" id="edit-nama" name="nama" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="edit-email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="edit-password" name="password" required>
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
    
    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserModalLabel">Delete User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin_delete_user.jsp" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="delete-id" name="id">
                        <p>Are you sure you want to delete the user <strong><span id="delete-user-name"></span></strong>?</p>
                        <p class="text-danger">This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript for modals -->
    <script>
        // Edit user modal data
        document.querySelectorAll('.btn-edit').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const nama = this.getAttribute('data-nama');
                const email = this.getAttribute('data-email');
                const password = this.getAttribute('data-password');
                
                document.getElementById('edit-id').value = id;
                document.getElementById('edit-nama').value = nama;
                document.getElementById('edit-email').value = email;
                document.getElementById('edit-password').value = password;
            });
        });
        
        // Delete user modal data
        document.querySelectorAll('.btn-delete').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const nama = this.getAttribute('data-nama');
                
                document.getElementById('delete-id').value = id;
                document.getElementById('delete-user-name').textContent = nama;
            });
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