<!-- filepath: d:\Project\WebApplication1\web\register_output.jsp -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Hasil Registrasi</title>
</head>
<body>
    <%
        // Get form parameters
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Database connection variables
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            
            // Open a connection
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String user = "root";
            String dbPassword = "";
            
            conn = DriverManager.getConnection(url, user, dbPassword);
            
            // SQL query
            String sql = "INSERT INTO user (nama, email, password) VALUES (?, ?, ?)";
            
            // Create prepared statement
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nama);
            pstmt.setString(2, email);
            pstmt.setString(3, password);
            
            // Execute the query
            pstmt.executeUpdate();
            
            // Display success message
            out.println("<h2>Registrasi Berhasil</h2>");
            out.println("<p>Terima kasih " + nama + " telah mendaftar!</p>");
            out.println("<p><a href='register.jsp'>Kembali ke Form Registrasi</a></p>");
            
        } catch(Exception e) {
            out.println("<h2>Error</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                out.println("<p>Error closing resources: " + se.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>