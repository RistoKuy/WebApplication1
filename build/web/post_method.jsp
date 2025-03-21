<%-- 
    Document   : post_method
    Created on : Mar 21, 2025, 2:42:49 PM
    Author     : Aristo Baadi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Using POST Method to read form data</h1>

        <ul>
            <li><p><b>First Name</b>
                First Name: <%= request.getParameter("first_name") %>
            </p></li>
            <li><p><b>Last Name</b>
                Last Name: <%= request.getParameter("last_name") %>
            </p></li>
        </ul>
    </body>
</html>
