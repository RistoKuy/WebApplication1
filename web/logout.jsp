<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();
    
    // Redirect to login page
    response.sendRedirect("login.jsp");
%>