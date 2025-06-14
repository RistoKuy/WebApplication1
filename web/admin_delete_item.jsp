<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@ page import="util.PathUtil" %>
<%@page import="java.util.*"%>
<%@page import="jakarta.servlet.http.*"%>
<%@page import="jakarta.servlet.ServletException"%>
<%@ page import="java.nio.file.*" %>
<%@page import="util.DatabaseUtil"%>
<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        // Redirect to login page if not logged in
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get parameters from form
    String id_brg = request.getParameter("id_brg");
      // Database connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
      try {
        // Connect to the database using environment configuration
        conn = util.DatabaseUtil.getConnection();
        
        // First get the image file name associated with this item
        String getImageSql = "SELECT gambar_brg FROM item WHERE id_brg = ?";
        pstmt = conn.prepareStatement(getImageSql);
        pstmt.setString(1, id_brg);
        rs = pstmt.executeQuery();
        
        String gambar_brg = null;
        if (rs.next()) {
            gambar_brg = rs.getString("gambar_brg");
        }
        
        // Close the result set and prepare for deletion
        if (rs != null) {
            rs.close();
            rs = null;
        }
        if (pstmt != null) {
            pstmt.close();
            pstmt = null;
        }
        
        // Delete the item record
        String sql = "DELETE FROM item WHERE id_brg = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id_brg);
        
        // Execute the query and check the result
        int rowsAffected = pstmt.executeUpdate();
        
        // If deletion was successful and there is an associated image, delete the file from persistent uploads directory
        if (rowsAffected > 0 && gambar_brg != null && !gambar_brg.isEmpty()) {
            // Delete from project's uploads directory using PathUtil for cross-environment compatibility
            String uploadsPath = PathUtil.getUploadsPath(application);
            File persistentImageFile = new File(uploadsPath + File.separator + gambar_brg);
            if (persistentImageFile.exists()) {
                persistentImageFile.delete();
            }
        }
        
        // Redirect with success or error message
        if (rowsAffected > 0) {
            response.sendRedirect("item_list.jsp?success=Item deleted successfully");
        } else {
            response.sendRedirect("item_list.jsp?error=Failed to delete item");
        }
        
    } catch (Exception e) {
        // Redirect with error message
        response.sendRedirect("item_list.jsp?error=Error: " + e.getMessage());
        
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            // Do nothing
        }
    }
%>
