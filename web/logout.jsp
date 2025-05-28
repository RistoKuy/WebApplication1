<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();
    
    // Redirect to index page
    response.sendRedirect("index.jsp");
%>

<!-- Include Firebase Configuration -->
<%@ include file="firebase_config.jsp" %>

<script type="module">
  // Sign out from Firebase Auth
  const result = await window.FirebaseUtils.logout();
  if (!result.success) {
    console.error('Firebase sign out failed:', result.error);
  }
</script>