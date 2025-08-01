<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.DatabaseUtil"%>

<%
    // Check if user is logged in (in a real app, check for admin role)
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get currently logged-in user's email
    String userEmail = (String) session.getAttribute("userEmail");
    
    // Get user ID to delete
    String idStr = request.getParameter("id");
    
    // Validate input data
    if (idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("account_list.jsp?error=User ID is required");
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
    int rowsDeleted = 0;
    
    try {
        // Register JDBC driver        // Connect to the database using environment configuration
        conn = util.DatabaseUtil.getConnection();// First, check if the user is trying to delete their own account
        String checkSql = "SELECT email FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, id);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next() && rs.getString("email").equals(userEmail)) {
            // Trying to delete own account
            if (rs != null) rs.close();
            response.sendRedirect("account_list.jsp?error=You cannot delete your own account");
            return;
        }
        
        // Close the result set after check
        if (rs != null) rs.close();
        
        // Create SQL DELETE statement
        String sql = "DELETE FROM user WHERE id = ?";
        
        // Create prepared statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        
        // Execute the delete
        rowsDeleted = pstmt.executeUpdate();
        
        if (rowsDeleted > 0) {
            // Redirect with success message
            response.sendRedirect("account_list.jsp?success=User deleted successfully");
        } else {
            // Redirect with error message
            response.sendRedirect("account_list.jsp?error=Failed to delete user. User ID may not exist.");
        }
    } catch(Exception e) {
        response.sendRedirect("account_list.jsp?error=" + e.getMessage());    } finally {
        try {
            // We already closed the result set after our check, but just to be safe
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException se) {
            // Do nothing
        }
    }
%>