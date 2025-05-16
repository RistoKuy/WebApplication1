<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get form data
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    // Validate the data
    if (nama == null || nama.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        response.sendRedirect("account_update.jsp?error=Name and password cannot be empty");
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
        String sql = "UPDATE user SET nama = ?, password = ? WHERE email = ?";
        
        // Create prepared statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nama);
        pstmt.setString(2, password);
        pstmt.setString(3, email);
        
        // Execute the update
        rowsUpdated = pstmt.executeUpdate();
          if (rowsUpdated > 0) {
            // Update session data
            session.setAttribute("userName", nama);
            
            // Get user role
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            boolean isAdminUser = (isAdmin != null && isAdmin);
            
            // Redirect with success message to appropriate page
            if (isAdminUser) {
                response.sendRedirect("dashboard.jsp?success=true");
            } else {
                response.sendRedirect("main.jsp?success=true");
            }
        } else {
            // Redirect with error message
            response.sendRedirect("account_update.jsp?error=Failed to update profile");
        }
    } catch(Exception e) {
        response.sendRedirect("account_update.jsp?error=" + e.getMessage());
    } finally {
        try {
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException se) {
            // Do nothing
        }
    }
%>