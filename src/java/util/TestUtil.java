package util;

import java.sql.*;

/**
 * A simple utility class with database helper functions
 */
public class TestUtil {
    
    /**
     * Returns a greeting message
     * @param name The name to greet
     * @return A greeting message
     */
    public static String greeting(String name) {
        return "Hello, " + name + "!";
    }
    
    /**
     * Checks if an email already exists in the database
     * @param email The email to check
     * @return true if the email exists, false otherwise
     */
    public static boolean isEmailExists(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Open a connection
            String url = "jdbc:mysql://localhost:3306/web_enterprise";
            String user = "root";
            String dbPassword = "";
            
            conn = DriverManager.getConnection(url, user, dbPassword);
            
            // SQL query to check if email exists
            String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
            
            // Create prepared statement
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            // Execute the query
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
            
        } catch(Exception e) {
            System.out.println("Error checking email: " + e.getMessage());
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                System.out.println("Error closing resources: " + se.getMessage());
            }
        }
        
        return exists;
    }
}