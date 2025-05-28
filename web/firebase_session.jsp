<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Set session for Firebase user
    String email = request.getParameter("email");
    String firebase_uid = request.getParameter("firebase_uid");
    if (email != null && !email.isEmpty()) {
        session.setAttribute("userEmail", email);
        session.setAttribute("isAdmin", false);
        session.setAttribute("loggedIn", true);
    }
    if (firebase_uid != null && !firebase_uid.isEmpty()) {
        session.setAttribute("firebase_uid", firebase_uid);
    }
%>
