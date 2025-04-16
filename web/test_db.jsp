<%-- 
    Document   : test_koneksi
    Created on : 16 Apr 2025, 11.18.54
    Author     : Aristo Baadi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Koneksi Database</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h1 {
                color: #333;
            }
            .success {
                color: green;
                padding: 10px;
                border: 1px solid green;
                background-color: #f0fff0;
            }
            .error {
                color: red;
                padding: 10px;
                border: 1px solid red;
                background-color: #fff0f0;
            }
        </style>
    </head>
    <body>
        <h1>Test Koneksi Database</h1>
        <%
            Connection conn = null;
            try {
                // Load the JDBC driver
                Class.forName("com.mysql.jdbc.Driver");
                
                // Database connection parameters
                String url = "jdbc:mysql://localhost:3306/web_enterprise";
                String username = "root";
                String password = "";
                
                // Establish connection
                conn = DriverManager.getConnection(url, username, password);
                
                if(conn != null) {
                    out.println("<div class='success'>Koneksi ke database berhasil!</div>");
                    out.println("<p>Database URL: " + url + "</p>");
                    out.println("<p>Status: " + !conn.isClosed() + "</p>");
                    
                    // Get database metadata
                    DatabaseMetaData metaData = conn.getMetaData();
                    out.println("<p>Database: " + metaData.getDatabaseProductName() + "</p>");
                    out.println("<p>Version: " + metaData.getDatabaseProductVersion() + "</p>");
                    out.println("<p>Driver: " + metaData.getDriverName() + "</p>");
                    out.println("<p>Driver Version: " + metaData.getDriverVersion() + "</p>");
                }
            } catch (ClassNotFoundException e) {
                out.println("<div class='error'>Driver JDBC MySQL tidak ditemukan: " + e.getMessage() + "</div>");
                out.println("<p>Pastikan library JDBC MySQL sudah ditambahkan di project</p>");
            } catch (SQLException e) {
                out.println("<div class='error'>Koneksi ke database gagal: " + e.getMessage() + "</div>");
                out.println("<p>Periksa parameter koneksi dan pastikan server MySQL sudah berjalan</p>");
            } finally {
                // Close connection if it was opened
                try {
                    if (conn != null && !conn.isClosed()) {
                        conn.close();
                        out.println("<p>Koneksi ditutup.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Error saat menutup koneksi: " + e.getMessage() + "</p>");
                }
            }
        %>
    </body>
</html>
