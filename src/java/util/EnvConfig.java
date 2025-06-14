package util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Environment configuration utility for reading environment variables
 * and configuration from .env files
 */
public class EnvConfig {
    private static Properties properties = new Properties();
    private static boolean initialized = false;
    
    static {
        loadConfig();
    }
      /**
     * Load configuration from .env file and system environment
     */
    private static void loadConfig() {
        if (initialized) return;
        
        // Try multiple locations for .env file
        String[] envPaths = {
            System.getProperty("user.dir") + "/.env",
            System.getProperty("user.dir") + "\\.env",
            "C:\\Project\\WebApplication1\\.env",
            ".env"
        };
        
        boolean envFileLoaded = false;
        for (String envPath : envPaths) {
            try {
                try (InputStream input = new FileInputStream(envPath)) {
                    properties.load(input);
                    System.out.println("Loaded .env from: " + envPath);
                    envFileLoaded = true;
                    break;
                }
            } catch (IOException e) {
                // Try next path
            }
        }
        
        if (!envFileLoaded) {
            System.out.println("Warning: Could not load .env file from any of the following locations:");
            for (String path : envPaths) {
                System.out.println("  - " + path);
            }
            System.out.println("Using system environment variables and defaults only.");
        }
          // Override with system environment variables if they exist
        for (String key : properties.stringPropertyNames()) {
            String envValue = System.getenv(key);
            if (envValue != null) {
                properties.setProperty(key, envValue);
                System.out.println("Override from env: " + key + " = " + envValue.substring(0, Math.min(10, envValue.length())) + "...");
            }
        }
        
        // Also check for environment variables that aren't in .env file
        String[] importantKeys = {"FIREBASE_API_KEY", "DB_URL", "DB_USERNAME"};
        for (String key : importantKeys) {
            String envValue = System.getenv(key);
            if (envValue != null && !properties.containsKey(key)) {
                properties.setProperty(key, envValue);
                System.out.println("Added from env: " + key + " = " + envValue.substring(0, Math.min(10, envValue.length())) + "...");
            }
        }
        
        initialized = true;
        System.out.println("EnvConfig initialized. Total properties: " + properties.size());
    }
    
    /**
     * Get a configuration value by key
     */
    public static String get(String key) {
        return get(key, null);
    }
    
    /**
     * Get a configuration value by key with default value
     */
    public static String get(String key, String defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            value = System.getenv(key);
        }
        return value != null ? value : defaultValue;
    }
    
    /**
     * Get integer configuration value
     */
    public static int getInt(String key, int defaultValue) {
        String value = get(key);
        if (value != null) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                System.err.println("Warning: Invalid integer value for " + key + ": " + value);
            }
        }
        return defaultValue;
    }
    
    /**
     * Get boolean configuration value
     */
    public static boolean getBoolean(String key, boolean defaultValue) {
        String value = get(key);
        if (value != null) {
            return Boolean.parseBoolean(value);
        }
        return defaultValue;
    }
    
    // Database Configuration
    public static String getDbUrl() {
        return get("DB_URL", "jdbc:mysql://localhost:3306/web_enterprise");
    }
    
    public static String getDbUsername() {
        return get("DB_USERNAME", "root");
    }
    
    public static String getDbPassword() {
        return get("DB_PASSWORD", "");
    }
    
    public static String getDbDriver() {
        return get("DB_DRIVER", "com.mysql.cj.jdbc.Driver");
    }
    
    // Firebase Configuration
    public static String getFirebaseApiKey() {
        return get("FIREBASE_API_KEY");
    }
    
    public static String getFirebaseAuthDomain() {
        return get("FIREBASE_AUTH_DOMAIN");
    }
    
    public static String getFirebaseProjectId() {
        return get("FIREBASE_PROJECT_ID");
    }
    
    public static String getFirebaseStorageBucket() {
        return get("FIREBASE_STORAGE_BUCKET");
    }
    
    public static String getFirebaseMessagingSenderId() {
        return get("FIREBASE_MESSAGING_SENDER_ID");
    }
    
    public static String getFirebaseAppId() {
        return get("FIREBASE_APP_ID");
    }
    
    public static String getFirebaseMeasurementId() {
        return get("FIREBASE_MEASUREMENT_ID");
    }
    
    public static String getFirebaseDatabaseUrl() {
        return get("FIREBASE_DATABASE_URL");
    }
    
    public static String getFirebaseServiceAccountPath() {
        return get("FIREBASE_SERVICE_ACCOUNT_PATH", "/WEB-INF/firebase-adminsdk.json");
    }
    
    // Application Configuration
    public static String getUploadDir() {
        return get("APP_UPLOAD_DIR", "uploads/");
    }
    
    public static int getSessionTimeout() {
        return getInt("APP_SESSION_TIMEOUT", 30);
    }
    
    public static int getPasswordMinLength() {
        return getInt("PASSWORD_MIN_LENGTH", 6);
    }
    
    public static boolean isSessionSecure() {
        return getBoolean("SESSION_SECURE", false);
    }
}
