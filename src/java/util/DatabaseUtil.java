package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection utility using environment configuration
 */
public class DatabaseUtil {
    
    /**
     * Get a database connection using environment configuration
     * @return Connection object
     * @throws SQLException if connection fails
     * @throws ClassNotFoundException if driver not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load database driver
        Class.forName(EnvConfig.getDbDriver());
        
        // Get connection using environment configuration
        return DriverManager.getConnection(
            EnvConfig.getDbUrl(),
            EnvConfig.getDbUsername(),
            EnvConfig.getDbPassword()
        );
    }
    
    /**
     * Close database connection safely
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get database connection info for debugging (without password)
     * @return String with connection info
     */
    public static String getConnectionInfo() {
        return String.format("Database: %s, User: %s", 
            EnvConfig.getDbUrl(), 
            EnvConfig.getDbUsername());
    }
}
