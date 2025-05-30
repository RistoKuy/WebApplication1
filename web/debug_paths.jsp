<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="util.PathUtil" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Path Debug Information</title>
    <style>
        body { font-family: monospace; background: #333; color: #fff; padding: 20px; }
        .info { background: #444; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .label { color: #87CEEB; font-weight: bold; }
        .value { color: #98FB98; }
        .exists { color: #90EE90; }
        .not-exists { color: #FFB6C1; }
    </style>
</head>
<body>
    <h1>Path Debug Information</h1>
    
    <div class="info">
        <div class="label">Application Real Path:</div>
        <div class="value"><%= application.getRealPath("/") %></div>
    </div>
    
    <div class="info">
        <div class="label">Working Directory:</div>
        <div class="value"><%= System.getProperty("user.dir") %></div>
    </div>
    
    <div class="info">
        <div class="label">PathUtil Project Root:</div>
        <div class="value"><%= PathUtil.getProjectRoot(application) %></div>
    </div>
    
    <div class="info">
        <div class="label">PathUtil Uploads Path:</div>
        <div class="value"><%= PathUtil.getUploadsPath(application) %></div>
    </div>
    
    <div class="info">
        <div class="label">Uploads Directory Exists:</div>
        <div class="<%= new File(PathUtil.getUploadsPath(application)).exists() ? "exists" : "not-exists" %>">
            <%= new File(PathUtil.getUploadsPath(application)).exists() ? "YES" : "NO" %>
        </div>
    </div>
    
    <div class="info">
        <div class="label">Project Source Directory Exists (c:\Project\WebApplication1):</div>
        <div class="<%= new File("c:\\Project\\WebApplication1").exists() ? "exists" : "not-exists" %>">
            <%= new File("c:\\Project\\WebApplication1").exists() ? "YES" : "NO" %>
        </div>
    </div>
    
    <h2>Debug Output (Check console/logs)</h2>
    <%
        PathUtil.debugPaths(application);
        out.println("<div class='info'>Debug information has been printed to the console/logs.</div>");
    %>
    
    <div class="info">
        <a href="javascript:history.back()" style="color: #87CEEB;">← Go Back</a>
    </div>
</body>
</html>
