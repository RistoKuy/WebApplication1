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
    String nama_brg = request.getParameter("nama_brg");
    String deskripsi = request.getParameter("deskripsi");
    String harga = request.getParameter("harga");
    String stokStr = request.getParameter("stok");
    int stok = 0;
    
    try {
        stok = Integer.parseInt(stokStr);
    } catch (NumberFormatException e) {
        stok = 0; // Default to 0 if parsing fails
    }
    
    // Handle image file upload
    String gambar_brg = "";
    Part filePart = null;
    
    try {
        filePart = request.getPart("gambar_file");
    } catch (Exception e) {
        // If there's an error getting the file part, continue without image
        System.out.println("Error getting file part: " + e.getMessage());
    }
    
    if (filePart != null && filePart.getSize() > 0) {
        String fileName = filePart.getSubmittedFileName();
        if (fileName != null && !fileName.isEmpty()) {
            // Generate a unique filename to prevent overwriting
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = "item_" + System.currentTimeMillis() + fileExtension;
            gambar_brg = uniqueFileName;
            
            // Get the absolute path to the img directory
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save the file to the server
            filePart.write(uploadPath + File.separator + uniqueFileName);
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
        
        // SQL query to insert new item
        String sql = "INSERT INTO item (nama_brg, deskripsi, harga, stok, gambar_brg) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nama_brg);
        pstmt.setString(2, deskripsi);
        pstmt.setString(3, harga);
        pstmt.setInt(4, stok);
        pstmt.setString(5, gambar_brg);
        
        // Execute the query and check the result
        int rowsAffected = pstmt.executeUpdate();
        
        // Redirect with success or error message
        if (rowsAffected > 0) {
            response.sendRedirect("item_list.jsp?success=Item added successfully");
        } else {
            response.sendRedirect("item_list.jsp?error=Failed to add item");
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
