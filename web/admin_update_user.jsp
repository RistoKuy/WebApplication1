<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
    // Check if user is logged in (in a real app, check for admin role)
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get currently logged-in user's email
    String userEmail = (String) session.getAttribute("userEmail");
    
    // Get form data
    String idStr = request.getParameter("id");
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    // Validate input data
    if (idStr == null || nama == null || email == null || password == null || 
        idStr.trim().isEmpty() || nama.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("account_list.jsp?error=All fields are required");
        return;
    }
    
    int id = 0;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("account_list.jsp?error=Invalid user ID");
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
          // First check if trying to update currently logged in user
        String checkSql = "SELECT email FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, id);
        ResultSet rs = pstmt.executeQuery();
          if (rs.next() && rs.getString("email").equals(userEmail)) {
            // Trying to update own account from admin page
            if (rs != null) rs.close();
            response.sendRedirect("account_list.jsp?error=Please use your profile page to update your own account");
            return;
        }
        
        // Close the result set after check
        if (rs != null) rs.close();
        
        // Check if email is being changed to the logged-in user's email
        if (email.equals(userEmail)) {
            response.sendRedirect("account_list.jsp?error=Cannot use your email for another account");
            return;
        }
        
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
            response.sendRedirect("account_list.jsp?success=User updated successfully");
        } else {
            // Redirect with error message
            response.sendRedirect("account_list.jsp?error=Failed to update user. User ID may not exist.");
        }
    } catch(Exception e) {
        response.sendRedirect("account_list.jsp?error=" + e.getMessage());
    } finally {        try {
            // We already closed the result set after our check, but just to be safe
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException se) {
            // Do nothing
        }
    }
%>