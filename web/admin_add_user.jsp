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
    
    // Get currently logged-in user's email
    String userEmail = (String) session.getAttribute("userEmail");
    
    // Get form data
    String nama = request.getParameter("nama");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    // Validate input data    if (nama == null || email == null || password == null || 
        nama.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("account_list.jsp?error=All fields are required");
        return;
    }
    
    // Check if trying to create a user with the same email as the logged-in user
    if (email.equals(userEmail)) {
        response.sendRedirect("account_list.jsp?error=Cannot create a new user with your email address");
        return;
    }
    
    // Database connection
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Register JDBC driver        // Connect to the database using environment configuration
        conn = util.DatabaseUtil.getConnection();
        
        // Check if email already exists
        String checkSql = "SELECT COUNT(*) AS count FROM user WHERE email = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, email);
        rs = pstmt.executeQuery();
        
        if (rs.next() && rs.getInt("count") > 0) {
            response.sendRedirect("account_list.jsp?error=Email already exists");
            return;
        }
        
        // Create SQL INSERT statement
        String sql = "INSERT INTO user (nama, email, password) VALUES (?, ?, ?)";
        
        // Create prepared statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nama);
        pstmt.setString(2, email);
        pstmt.setString(3, password);
        
        // Execute the insert
        int rowsInserted = pstmt.executeUpdate();
        
        if (rowsInserted > 0) {
            // Redirect with success message
            response.sendRedirect("account_list.jsp?success=User added successfully");
        } else {
            // Redirect with error message
            response.sendRedirect("account_list.jsp?error=Failed to add user");
        }
    } catch(Exception e) {
        response.sendRedirect("account_list.jsp?error=" + e.getMessage());
    } finally {
        try {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException se) {
            // Do nothing
        }
    }
%>