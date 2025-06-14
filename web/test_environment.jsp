<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="util.EnvConfig"%>
<%@page import="util.DatabaseUtil"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Environment Configuration Test</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
    <div class="container py-5">
        <h2 class="mb-4">🔧 Environment Configuration Test</h2>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card bg-secondary">
                    <div class="card-header">
                        <h5>📊 Database Configuration</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>URL:</strong> <%= EnvConfig.getDbUrl() %></p>
                        <p><strong>Username:</strong> <%= EnvConfig.getDbUsername() %></p>
                        <p><strong>Driver:</strong> <%= EnvConfig.getDbDriver() %></p>
                        
                        <hr>
                        <h6>Connection Test:</h6>
                        <%
                        try {
                            Connection conn = DatabaseUtil.getConnection();
                            if (conn != null) {
                                out.println("<span class='text-success'>✅ Database connection successful!</span>");
                                conn.close();
                            } else {
                                out.println("<span class='text-danger'>❌ Database connection failed - null connection</span>");
                            }
                        } catch (Exception e) {
                            out.println("<span class='text-danger'>❌ Database connection failed: " + e.getMessage() + "</span>");
                        }
                        %>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card bg-secondary">
                    <div class="card-header">
                        <h5>🔥 Firebase Configuration</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Project ID:</strong> <%= EnvConfig.getFirebaseProjectId() %></p>
                        <p><strong>Auth Domain:</strong> <%= EnvConfig.getFirebaseAuthDomain() %></p>
                        <p><strong>API Key:</strong> <%= EnvConfig.getFirebaseApiKey() != null ? EnvConfig.getFirebaseApiKey().substring(0, 10) + "..." : "Not set" %></p>
                        <p><strong>Service Account Path:</strong> <%= EnvConfig.getFirebaseServiceAccountPath() %></p>
                        
                        <hr>
                        <h6>Service Account File Test:</h6>
                        <%
                        try {
                            String serviceAccountPath = application.getRealPath(EnvConfig.getFirebaseServiceAccountPath());
                            java.io.File serviceAccountFile = new java.io.File(serviceAccountPath);
                            
                            if (serviceAccountFile.exists()) {
                                out.println("<span class='text-success'>✅ Firebase service account file found</span>");
                            } else {
                                out.println("<span class='text-warning'>⚠️ Firebase service account file not found at: " + serviceAccountPath + "</span>");
                            }
                        } catch (Exception e) {
                            out.println("<span class='text-danger'>❌ Error checking Firebase service account: " + e.getMessage() + "</span>");
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="card bg-secondary">
                    <div class="card-header">
                        <h5>⚙️ Application Configuration</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <p><strong>Upload Directory:</strong> <%= EnvConfig.getUploadDir() %></p>
                                <p><strong>Session Timeout:</strong> <%= EnvConfig.getSessionTimeout() %> minutes</p>
                            </div>
                            <div class="col-md-4">
                                <p><strong>Password Min Length:</strong> <%= EnvConfig.getPasswordMinLength() %> characters</p>
                                <p><strong>Session Secure:</strong> <%= EnvConfig.isSessionSecure() %></p>
                            </div>
                            <div class="col-md-4">
                                <p><strong>Environment Status:</strong> 
                                    <% 
                                    if (EnvConfig.get("DB_URL") != null && EnvConfig.getFirebaseApiKey() != null) {
                                        out.println("<span class='text-success'>✅ Configured</span>");
                                    } else {
                                        out.println("<span class='text-danger'>❌ Missing configuration</span>");
                                    }
                                    %>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="index.jsp" class="btn btn-primary">← Back to Home</a>
            <a href="main.jsp" class="btn btn-secondary">Go to Main Page</a>
        </div>
        
        <div class="alert alert-info mt-4">
            <h6>📖 Configuration Help</h6>
            <ul class="mb-0">
                <li>If you see connection errors, check your <code>.env</code> file</li>
                <li>Make sure <code>firebase-adminsdk.json</code> is in <code>web/WEB-INF/</code></li>
                <li>See <code>ENVIRONMENT_CONFIG.md</code> for detailed setup instructions</li>
                <li>Use <code>.env.example</code> as a template for your configuration</li>
            </ul>
        </div>
    </div>
</body>
</html>
