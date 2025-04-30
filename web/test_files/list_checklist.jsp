<%-- 
    Document   : list_checklist
    Created on : Mar 21, 2025, 3:01:04 PM
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
        <h1>Reading Checkbox Data</h1>

        <ul>
            <li><p><b>Math Flags: </b>
                <%= request.getParameter("maths") %>
            </p></li>
            <li><p><b>Science Flags: </b>
                <%= request.getParameter("science") %>
            </p></li>
            <li><p><b>Chermistry Flags: </b>
                <%= request.getParameter("chermistry") %>
            </p></li>
        </ul>
    </body>
</html>
