<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="jakarta.servlet.http.*"%>
<%@page import="jakarta.servlet.ServletException"%>
<%@ page import="java.nio.file.*" %>
<%@ page import="util.PathUtil" %>
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
    String nama_brg = request.getParameter("nama_brg");
    String deskripsi = request.getParameter("deskripsi");
    String harga = request.getParameter("harga");
    String stokStr = request.getParameter("stok");
    String current_gambar = request.getParameter("current_gambar");
    int stok = 0;
    
    // Validate required form fields
    if (nama_brg == null || nama_brg.trim().isEmpty()) {
        response.sendRedirect("item_list.jsp?error=Item name cannot be empty");
        return;
    }
    // Validate harga is a valid number (integer or decimal)
    try {
        Double.parseDouble(harga);
    } catch (NumberFormatException e) {
        response.sendRedirect("item_list.jsp?error=Harga harus berupa angka!");
        return;
    }
    // Validate stok is a valid integer and non-negative
    if (stokStr == null || stokStr.trim().isEmpty()) {
        response.sendRedirect("item_list.jsp?error=Stok tidak boleh kosong!");
        return;
    }
    try {
        stok = Integer.parseInt(stokStr);
        if (stok < 0) {
            response.sendRedirect("item_list.jsp?error=Stok tidak boleh negatif!");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("item_list.jsp?error=Stok harus berupa angka bulat!");
        return;
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
            String uniqueFileName = "item_" + System.currentTimeMillis() + fileExtension;            // Save the file using the PathUtil utility for cross-environment compatibility
            File uploadDir = PathUtil.getUploadsDirectory(application);
            // Debug output for file save path
            System.out.println("[DEBUG] Saving file to: " + uploadDir.getAbsolutePath() + File.separator + uniqueFileName);
            // Use stream copy instead of filePart.write
            try (InputStream input = filePart.getInputStream();
                 OutputStream output = new FileOutputStream(new File(uploadDir, uniqueFileName))) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }            }
            
            // Update gambar_brg to use the new filename
            gambar_brg = uniqueFileName;
            
            // If this is a new image and there was an old one, delete the old one from persistent dir
            if (current_gambar != null && !current_gambar.isEmpty()) {
                File oldFile = new File(uploadDir.getAbsolutePath() + File.separator + current_gambar);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
        }
    }
    
    // Database connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
      try {
        // Connect to the database using environment configuration
        conn = util.DatabaseUtil.getConnection();
        
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
