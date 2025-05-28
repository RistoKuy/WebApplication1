<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Set session for Firebase user
    String email = request.getParameter("email");
    if (email != null && !email.isEmpty()) {
        session.setAttribute("userEmail", email);
        session.setAttribute("isAdmin", false);
        session.setAttribute("loggedIn", true);
    }
%>
