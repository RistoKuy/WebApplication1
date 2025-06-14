<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="util.EnvConfig"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Debug Environment Configuration</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
    <div class="container py-5">
        <h2 class="mb-4">🐛 Debug Environment Configuration</h2>
        
        <div class="card bg-secondary">
            <div class="card-header">
                <h5>Environment Variable Values</h5>
            </div>
            <div class="card-body">
                <table class="table table-dark">
                    <tr>
                        <td><strong>FIREBASE_API_KEY:</strong></td>
                        <td><code><%= EnvConfig.getFirebaseApiKey() %></code></td>
                    </tr>
                    <tr>
                        <td><strong>FIREBASE_AUTH_DOMAIN:</strong></td>
                        <td><code><%= EnvConfig.getFirebaseAuthDomain() %></code></td>
                    </tr>
                    <tr>
                        <td><strong>FIREBASE_PROJECT_ID:</strong></td>
                        <td><code><%= EnvConfig.getFirebaseProjectId() %></code></td>
                    </tr>
                    <tr>
                        <td><strong>DB_URL:</strong></td>
                        <td><code><%= EnvConfig.getDbUrl() %></code></td>
                    </tr>
                    <tr>
                        <td><strong>DB_USERNAME:</strong></td>
                        <td><code><%= EnvConfig.getDbUsername() %></code></td>
                    </tr>
                </table>
                
                <hr>
                
                <h6>Raw Environment Tests:</h6>
                <p><strong>System Property user.dir:</strong> <%= System.getProperty("user.dir") %></p>
                <p><strong>Environment FIREBASE_API_KEY:</strong> <%= System.getenv("FIREBASE_API_KEY") %></p>
                <p><strong>Class Location:</strong> 
                <%
                try {
                    String classPath = EnvConfig.class.getProtectionDomain().getCodeSource().getLocation().toString();
                    out.print(classPath);
                } catch (Exception e) {
                    out.print("Error: " + e.getMessage());
                }
                %>
                </p>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="login.jsp" class="btn btn-primary">← Back to Login</a>
            <a href="test_environment.jsp" class="btn btn-secondary">Environment Test</a>
        </div>
    </div>
</body>
</html>
