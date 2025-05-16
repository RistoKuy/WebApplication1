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
    String nama_brg = request.getParameter("nama_brg");
    String deskripsi = request.getParameter("deskripsi");
    String harga = request.getParameter("harga");
    String stokStr = request.getParameter("stok");
    String current_gambar = request.getParameter("current_gambar");
    int stok = 0;
    
    try {
        stok = Integer.parseInt(stokStr);
    } catch (NumberFormatException e) {
        stok = 0; // Default to 0 if parsing fails
    }
    
    // Handle image file upload
    String gambar_brg = current_gambar; // Keep current image by default
    Part filePart = null;
    
    try {
        filePart = request.getPart("gambar_file");
    } catch (Exception e) {
        // If there's an error getting the file part, continue with current image
        System.out.println("Error getting file part: " + e.getMessage());
    }
      if (filePart != null && filePart.getSize() > 0) {
        String fileName = filePart.getSubmittedFileName();
        if (fileName != null && !fileName.isEmpty()) {
            // Generate a unique filename to prevent overwriting
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = "item_" + System.currentTimeMillis() + fileExtension;
            gambar_brg = uniqueFileName;
            
            // Get the absolute path to the build directory img folder
            String buildUploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
            File buildUploadDir = new File(buildUploadPath);
            if (!buildUploadDir.exists()) {
                buildUploadDir.mkdirs();
            }
            
            // Save the file to the build directory
            filePart.write(buildUploadPath + File.separator + uniqueFileName);

            // Define the source file for copying (must be after filePart.write)
            File sourceFile = new File(buildUploadPath + File.separator + uniqueFileName);
            // Now also copy to the persistent web/assets/img directory
            try {
                // Get the build directory (build/web)
                String buildDirPath = getServletContext().getRealPath("");
                File buildDir = new File(buildDirPath);
                // Go up two levels to get the project root
                String projectRoot = buildDir.getParentFile().getParent();
                String persistentAssetsPath = projectRoot + File.separator + "web" + File.separator + "assets" + File.separator + "img";
                File persistentAssetsDir = new File(persistentAssetsPath);
                if (!persistentAssetsDir.exists()) {
                    boolean created = persistentAssetsDir.mkdirs();
                    if (!created) {
                        System.out.println("Failed to create persistent web assets directory: " + persistentAssetsPath);
                    }
                }
                File persistentDestFile = new File(persistentAssetsPath + File.separator + uniqueFileName);
                try {
                    Files.copy(sourceFile.toPath(), persistentDestFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("Image saved to both build and persistent web/assets/img directories");
                } catch(Exception e) {
                    System.out.println("Error copying file to persistent web/assets/img: " + e.getMessage());
                }
            } catch(Exception e) {
                System.out.println("Error preparing persistent web/assets/img directory: " + e.getMessage());
            }
            
            // If this is a new image and there was an old one, delete the old ones (from both directories)
            if (current_gambar != null && !current_gambar.isEmpty()) {
                try {
                    // Delete from build directory
                    File oldBuildFile = new File(buildUploadPath + File.separator + current_gambar);
                    if (oldBuildFile.exists()) {
                        oldBuildFile.delete();
                    }

                    // Delete from persistent web/assets/img directory
                    // Get the build directory (build/web)
                    String buildDirPathDel = getServletContext().getRealPath("");
                    File buildDirDel = new File(buildDirPathDel);
                    // Go up two levels to get the project root
                    String projectRootDel = buildDirDel.getParentFile().getParent();
                    String persistentAssetsPathDel = projectRootDel + File.separator + "web" + File.separator + "assets" + File.separator + "img";
                    File oldWebFile = new File(persistentAssetsPathDel + File.separator + current_gambar);
                    if (oldWebFile.exists()) {
                        oldWebFile.delete();
                    }
                } catch (Exception e) {
                    // Ignore if can't delete old files
                    System.out.println("Error deleting old image: " + e.getMessage());
                }
            }
        }
    }
    
    // Database connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        // Load the database driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Connect to the database
        String url = "jdbc:mysql://localhost:3306/web_enterprise";
        String dbUser = "root";
        String dbPassword = "";
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        
        // SQL query to update item
        String sql = "UPDATE item SET nama_brg = ?, deskripsi = ?, harga = ?, stok = ?, gambar_brg = ? WHERE id_brg = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nama_brg);
        pstmt.setString(2, deskripsi);
        pstmt.setString(3, harga);
        pstmt.setInt(4, stok);
        pstmt.setString(5, gambar_brg);
        pstmt.setString(6, id_brg);
        
        // Execute the query and check the result
        int rowsAffected = pstmt.executeUpdate();
        
        // Redirect with success or error message
        if (rowsAffected > 0) {
            response.sendRedirect("item_list.jsp?success=Item updated successfully");
        } else {
            response.sendRedirect("item_list.jsp?error=Failed to update item");
        }
        
    } catch (Exception e) {
        // Redirect with error message
        response.sendRedirect("item_list.jsp?error=Error: " + e.getMessage());
        
    } finally {
        // Close resources
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            // Do nothing
        }
    }
%>
