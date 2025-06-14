<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.DatabaseUtil"%>
<%
    // Check if user is logged in (in a real app, check for admin role)
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get form data
    String idStr = request.getParameter("id");
    String newRole = request.getParameter("is_admin");
    String userEmail = (String) session.getAttribute("userEmail");

    if (idStr == null || newRole == null || idStr.trim().isEmpty() || newRole.trim().isEmpty()) {
        response.sendRedirect("account_list.jsp?error=Invalid role update request");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("account_list.jsp?error=Invalid user ID");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;    try {
        // Connect to the database using environment configuration
        conn = util.DatabaseUtil.getConnection();

        // Prevent changing your own role from this page
        String checkSql = "SELECT email FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();
        if (rs.next() && rs.getString("email").equals(userEmail)) {
            if (rs != null) rs.close();
            response.sendRedirect("account_list.jsp?error=Cannot change your own role from this page");
            return;
        }
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();

        // Update role
        String sql = "UPDATE user SET is_admin = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, newRole);
        pstmt.setInt(2, id);
        int updated = pstmt.executeUpdate();
        if (updated > 0) {
            response.sendRedirect("account_list.jsp?success=Role updated successfully");
        } else {
            response.sendRedirect("account_list.jsp?error=Failed to update role");
        }
    } catch(Exception e) {
        response.sendRedirect("account_list.jsp?error=" + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch(SQLException se) {}
    }
%>
