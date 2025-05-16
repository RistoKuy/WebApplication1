package util;

import java.sql.*;

/**
 * Utility class for admin-related operations
 */
public class AdminUtil {
    
    /**
     * Checks if a given email exists in the database and is an admin
     * @param email The email to check
     * @return true if the email exists and is an admin, false otherwise
     */
    public static boolean isAdmin(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isAdmin = false;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Open a connection
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String user = "root";
            String dbPassword = "";
            
            conn = DriverManager.getConnection(url, user, dbPassword);
            
            // SQL query to check if user exists and is admin
            String sql = "SELECT is_admin FROM user WHERE email = ?";
            
            // Create prepared statement
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            // Execute the query
            rs = pstmt.executeQuery();
            
            // Check if user exists and is admin
            if (rs.next()) {
                isAdmin = rs.getInt("is_admin") == 1;
            }
            
        } catch(Exception e) {
            // Log the error or handle it as needed
            e.printStackTrace();
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                // Log the error or handle it as needed
                se.printStackTrace();
            }
        }
        
        return isAdmin;
    }
}
