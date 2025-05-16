<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.servlet.http.*"%>
<%@page import="jakarta.servlet.ServletException"%>
<%@ page import="java.nio.file.*" %>
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
        // Load the database driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Connect to the database
        String url = "jdbc:mysql://localhost:3306/web_enterprise";
        String dbUser = "root";
        String dbPassword = "";
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        
        // First get the image file name associated with this item
        String getImageSql = "SELECT gambar_brg FROM item WHERE id_brg = ?";
        pstmt = conn.prepareStatement(getImageSql);
        pstmt.setString(1, id_brg);
        rs = pstmt.executeQuery();
        
        String gambar_brg = null;
        if (rs.next()) {
            gambar_brg = rs.getString("gambar_brg");
        }
        
        // Close the result set
        if (rs != null) {
            rs.close();
        }
        
        // Delete the item record
        String sql = "DELETE FROM item WHERE id_brg = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id_brg);
        
        // Execute the query and check the result
        int rowsAffected = pstmt.executeUpdate();
          // If deletion was successful and there is an associated image, delete the file from both locations
        if (rowsAffected > 0 && gambar_brg != null && !gambar_brg.isEmpty()) {
            // Delete from build directory
            String buildUploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
            File buildImageFile = new File(buildUploadPath + File.separator + gambar_brg);
            if (buildImageFile.exists()) {
                buildImageFile.delete();
            }
            
            // Delete from web directory
            try {
                String webDirPath = request.getServletContext().getRealPath("/");
                File webDir = new File(webDirPath);
                String projectRoot = webDir.getParent(); // Go up from build to project root
                String webAssetsPath = projectRoot + File.separator + "web" + File.separator + "assets" + File.separator + "img";
                
                File webImageFile = new File(webAssetsPath + File.separator + gambar_brg);
                if (webImageFile.exists()) {
                    webImageFile.delete();
                }
            } catch(Exception e) {
                System.out.println("Error deleting file from web directory: " + e.getMessage());
                // Continue execution even if deletion from web directory fails
            }

            // Delete from persistent web/assets/img directory
            try {
                // Get the build directory (build/web)
                String buildDirPathDel = getServletContext().getRealPath("");
                File buildDirDel = new File(buildDirPathDel);
                // Go up two levels to get the project root
                String projectRootDel = buildDirDel.getParentFile().getParent();
                String persistentAssetsPathDel = projectRootDel + File.separator + "web" + File.separator + "assets" + File.separator + "img";
                File webImageFile = new File(persistentAssetsPathDel + File.separator + gambar_brg);
                if (webImageFile.exists()) {
                    webImageFile.delete();
                }
            } catch(Exception e) {
                System.out.println("Error deleting file from persistent web/assets/img: " + e.getMessage());
                // Continue execution even if deletion from persistent directory fails
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
