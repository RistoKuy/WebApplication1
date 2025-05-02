<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    // Check if user is logged in (in a real app, check for admin role)
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get form data
    String idStr = request.getParameter("id");
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    // Validate input data
    if (idStr == null || nama == null || email == null || password == null || 
        idStr.trim().isEmpty() || nama.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("admin_panel.jsp?error=All fields are required");
        return;
    }
    
    int id = 0;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("admin_panel.jsp?error=Invalid user ID");
        return;
    }
    
    // Database connection
    Connection conn = null;
    PreparedStatement pstmt = null;
    int rowsUpdated = 0;
    
    try {
        // Register JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Open a connection
        String url = "jdbc:mysql://localhost:3306/web_enterprise";
        String dbUser = "root";
        String dbPassword = "";
        
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        
        // Create SQL UPDATE statement
        String sql = "UPDATE user SET nama = ?, email = ?, password = ? WHERE id = ?";
        
        // Create prepared statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nama);
        pstmt.setString(2, email);
        pstmt.setString(3, password);
        pstmt.setInt(4, id);
        
        // Execute the update
        rowsUpdated = pstmt.executeUpdate();
        
        if (rowsUpdated > 0) {
            // Redirect with success message
            response.sendRedirect("admin_panel.jsp?success=User updated successfully");
        } else {
            // Redirect with error message
            response.sendRedirect("admin_panel.jsp?error=Failed to update user. User ID may not exist.");
        }
    } catch(Exception e) {
        response.sendRedirect("admin_panel.jsp?error=" + e.getMessage());
    } finally {
        try {
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException se) {
            // Do nothing
        }
    }
%>