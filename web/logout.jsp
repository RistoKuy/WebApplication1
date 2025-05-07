<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();
    
    // Redirect to index page
    response.sendRedirect("index.jsp");
%>