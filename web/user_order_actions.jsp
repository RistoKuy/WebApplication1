<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DatabaseUtil"%>
<%-- User Order Actions Handler --%>
<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.setStatus(403);
        out.print("Unauthorized access");
        return;
    }

    // Get firebase_uid from session
    String firebase_uid = (String) session.getAttribute("firebase_uid");
    if (firebase_uid == null || firebase_uid.isEmpty()) {
        response.setStatus(400);
        out.print("User identification not found");
        return;
    }    String action = request.getParameter("action");
    String orderIdStr = request.getParameter("order_id");
    String checkoutIdStr = request.getParameter("id_checkout");
    
    if (action == null) {
        response.setStatus(400);
        out.print("Missing action parameter");
        return;
    }
      Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");        conn = util.DatabaseUtil.getConnection();
        
        if ("cancel_order".equals(action) && orderIdStr != null) {
            int orderId = Integer.parseInt(orderIdStr);
            // Legacy individual order cancellation
            // Start transaction
            conn.setAutoCommit(false);
            
            // First verify that this order belongs to the current user and is still pending
            String checkSql = "SELECT id_brg, jumlah, status_order FROM `order` WHERE id_order = ? AND firebase_uid = ? AND status_order = 'pending'";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, orderId);
            pstmt.setString(2, firebase_uid);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int itemId = rs.getInt("id_brg");
                int quantity = rs.getInt("jumlah");
                
                // Restore stock for the item
                String restoreStockSql = "UPDATE item SET stok = stok + ? WHERE id_brg = ?";
                PreparedStatement stockPstmt = conn.prepareStatement(restoreStockSql);
                stockPstmt.setInt(1, quantity);
                stockPstmt.setInt(2, itemId);
                stockPstmt.executeUpdate();
                stockPstmt.close();
                
                // Update order status to cancelled
                String updateOrderSql = "UPDATE `order` SET status_order = 'cancelled' WHERE id_order = ?";
                PreparedStatement updateOrderPstmt = conn.prepareStatement(updateOrderSql);
                updateOrderPstmt.setInt(1, orderId);
                updateOrderPstmt.executeUpdate();
                updateOrderPstmt.close();
                
                // Commit transaction
                conn.commit();
                out.print("success");
            } else {
                conn.rollback();
                out.print("Order not found or not eligible for cancellation");            }
            rs.close();
            pstmt.close();
        } else if ("cancel_checkout".equals(action) && checkoutIdStr != null) {
            
            int checkoutId = Integer.parseInt(checkoutIdStr);
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // Get all orders in this checkout that belong to the user and are pending
            String checkoutOrdersSql = "SELECT id_order, id_brg, jumlah FROM `order` WHERE id_checkout = ? AND firebase_uid = ? AND status_order = 'pending'";
            pstmt = conn.prepareStatement(checkoutOrdersSql);
            pstmt.setInt(1, checkoutId);
            pstmt.setString(2, firebase_uid);
            ResultSet rs = pstmt.executeQuery();
            
            boolean hasOrders = false;
            while (rs.next()) {
                hasOrders = true;
                int itemId = rs.getInt("id_brg");
                int quantity = rs.getInt("jumlah");
                
                // Restore stock for each item
                String restoreStockSql = "UPDATE item SET stok = stok + ? WHERE id_brg = ?";
                PreparedStatement stockPstmt = conn.prepareStatement(restoreStockSql);
                stockPstmt.setInt(1, quantity);
                stockPstmt.setInt(2, itemId);
                stockPstmt.executeUpdate();
                stockPstmt.close();
            }
            rs.close();
            
            if (hasOrders) {
                // Update all orders in this checkout to cancelled
                String updateCheckoutSql = "UPDATE `order` SET status_order = 'cancelled' WHERE id_checkout = ? AND firebase_uid = ?";
                PreparedStatement updateCheckoutPstmt = conn.prepareStatement(updateCheckoutSql);
                updateCheckoutPstmt.setInt(1, checkoutId);
                updateCheckoutPstmt.setString(2, firebase_uid);
                updateCheckoutPstmt.executeUpdate();
                updateCheckoutPstmt.close();
                
                // Commit transaction
                conn.commit();
                out.print("success");
            } else {
                conn.rollback();
                out.print("No pending orders found for this checkout");            }
            rs.close();
            pstmt.close();
        } else {
            out.print("Invalid action");
        }
        
    } catch(Exception e) {
        try {
            if (conn != null) {
                conn.rollback();
            }
        } catch(SQLException se) {
            // Handle rollback exception
        }
        out.print("Error: " + e.getMessage());
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch(SQLException e) {
            // Handle cleanup exception
        }
    }
%>
