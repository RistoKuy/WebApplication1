package util;

import java.io.File;
import jakarta.servlet.ServletContext;

/**
 * Utility class for handling file paths across different deployment environments
 * Handles both development (NetBeans) and production (Tomcat webapps) deployments
 */
public class PathUtil {
    
    /**
     * Gets the project root directory, whether in development or production mode
     * @param servletContext The servlet context
     * @return The absolute path to the project root directory
     */
    public static String getProjectRoot(ServletContext servletContext) {
        String realPath = servletContext.getRealPath("/");
        
        // Check if we're in development mode (NetBeans build directory)
        if (realPath.contains("build" + File.separator + "web")) {
            return realPath.replaceAll("\\\\build\\\\web\\\\?$", "").replaceAll("/build/web/?$", "");
        } else {
            // We're in production mode (deployed to webapps)
            // Try to find the source project directory using multiple strategies
            
            // Strategy 1: Try the exact project path
            File projectDir = new File("c:\\Project\\WebApplication1");
            if (projectDir.exists()) {
                return projectDir.getAbsolutePath();
            }
            
            // Strategy 2: Try relative to current working directory
            File currentDir = new File(System.getProperty("user.dir"));
            File relativeProject = new File(currentDir, "WebApplication1");
            if (relativeProject.exists()) {
                return relativeProject.getAbsolutePath();
            }
            
            // Strategy 3: Try to find parent directory that contains the project
            File parentDir = currentDir.getParentFile();
            if (parentDir != null) {
                File projectInParent = new File(parentDir, "WebApplication1");
                if (projectInParent.exists()) {
                    return projectInParent.getAbsolutePath();
                }
            }
            
            // Strategy 4: Check if uploads directory exists in webapp and use it
            File webappUploads = new File(realPath, "uploads");
            if (webappUploads.exists()) {
                return realPath;
            }
            
            // Fallback: Create uploads in webapp directory
            System.out.println("[PathUtil] Using fallback: webapp directory for uploads");
            return realPath;
        }
    }
    
    /**
     * Gets the uploads directory path
     * @param servletContext The servlet context
     * @return The absolute path to the uploads directory
     */
    public static String getUploadsPath(ServletContext servletContext) {
        return getProjectRoot(servletContext) + File.separator + "uploads";
    }
    
    /**
     * Gets the uploads directory as a File object
     * @param servletContext The servlet context
     * @return The uploads directory as a File object
     */
    public static File getUploadsDirectory(ServletContext servletContext) {
        String uploadsPath = getUploadsPath(servletContext);
        File uploadsDir = new File(uploadsPath);
        if (!uploadsDir.exists()) {
            boolean created = uploadsDir.mkdirs();
            if (created) {
                System.out.println("[PathUtil] Created uploads directory: " + uploadsDir.getAbsolutePath());
            } else {
                System.err.println("[PathUtil] Failed to create uploads directory: " + uploadsDir.getAbsolutePath());
            }
        }
        return uploadsDir;
    }
    
    /**
     * Debug method to print path resolution information
     * @param servletContext The servlet context
     */
    public static void debugPaths(ServletContext servletContext) {
        String realPath = servletContext.getRealPath("/");
        String projectRoot = getProjectRoot(servletContext);
        String uploadsPath = getUploadsPath(servletContext);
        
        System.out.println("[PathUtil Debug]");
        System.out.println("  Real Path: " + realPath);
        System.out.println("  Project Root: " + projectRoot);
        System.out.println("  Uploads Path: " + uploadsPath);
        System.out.println("  Working Directory: " + System.getProperty("user.dir"));
        System.out.println("  Uploads Directory Exists: " + new File(uploadsPath).exists());
    }
}
