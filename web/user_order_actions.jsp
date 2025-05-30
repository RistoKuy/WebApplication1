<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
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
    }

    String action = request.getParameter("action");
    String invoiceIdStr = request.getParameter("invoice_id");
    
    if (action == null || invoiceIdStr == null) {
        response.setStatus(400);
        out.print("Missing required parameters");
        return;
    }
    
    int invoiceId = Integer.parseInt(invoiceIdStr);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/web_enterprise";
        String dbUser = "root";
        String dbPassword = "";
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        
        if ("cancel_order".equals(action)) {
            // Start transaction
            conn.setAutoCommit(false);
            
            // First verify that this invoice belongs to the current user and is still pending
            String checkSql = "SELECT id_order, status_order FROM `invoice` WHERE id_invoice = ? AND firebase_uid = ? AND status_order = 'pending'";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, invoiceId);
            pstmt.setString(2, firebase_uid);
            ResultSet rs = pstmt.executeQuery();            if (rs.next()) {
                int orderId = rs.getInt("id_order");
                
                // Get the order details to find related orders in the same checkout session
                String orderDetailsSql = "SELECT firebase_uid, metode_pengiriman, metode_pembayaran, tgl_order FROM `order` WHERE id_order = ? AND firebase_uid = ?";
                PreparedStatement orderDetailsPstmt = conn.prepareStatement(orderDetailsSql);
                orderDetailsPstmt.setInt(1, orderId);
                orderDetailsPstmt.setString(2, firebase_uid);
                ResultSet orderDetailsRs = orderDetailsPstmt.executeQuery();
                
                if (orderDetailsRs.next()) {
                    String metodePengiriman = orderDetailsRs.getString("metode_pengiriman");
                    String metodePembayaran = orderDetailsRs.getString("metode_pembayaran");
                    java.sql.Timestamp orderTime = orderDetailsRs.getTimestamp("tgl_order");
                    
                    // Find ALL orders from the same checkout session and restore their stock
                    String relatedOrdersSql = "SELECT id_brg, jumlah, id_order FROM `order` WHERE firebase_uid = ? AND metode_pengiriman = ? AND metode_pembayaran = ? AND ABS(TIMESTAMPDIFF(SECOND, tgl_order, ?)) <= 300";
                    PreparedStatement relatedOrdersPstmt = conn.prepareStatement(relatedOrdersSql);
                    relatedOrdersPstmt.setString(1, firebase_uid);
                    relatedOrdersPstmt.setString(2, metodePengiriman);
                    relatedOrdersPstmt.setString(3, metodePembayaran);
                    relatedOrdersPstmt.setTimestamp(4, orderTime);
                    ResultSet relatedOrdersRs = relatedOrdersPstmt.executeQuery();
                    
                    // Restore stock for all related items and update their status
                    while (relatedOrdersRs.next()) {
                        int itemId = relatedOrdersRs.getInt("id_brg");
                        int quantity = relatedOrdersRs.getInt("jumlah");
                        int relatedOrderId = relatedOrdersRs.getInt("id_order");
                        
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
                        updateOrderPstmt.setInt(1, relatedOrderId);
                        updateOrderPstmt.executeUpdate();
                        updateOrderPstmt.close();
                    }
                    relatedOrdersRs.close();
                    relatedOrdersPstmt.close();
                }
                orderDetailsRs.close();
                orderDetailsPstmt.close();
                
                // Update invoice status to cancelled
                String updateInvoiceSql = "UPDATE `invoice` SET status_order = 'cancelled' WHERE id_invoice = ?";
                PreparedStatement updateInvoicePstmt = conn.prepareStatement(updateInvoiceSql);
                updateInvoicePstmt.setInt(1, invoiceId);
                updateInvoicePstmt.executeUpdate();
                updateInvoicePstmt.close();
                
                // Commit transaction
                conn.commit();
                out.print("success");
            } else {
                conn.rollback();
                out.print("Order not found or not eligible for cancellation");
            }
            rs.close();
        } else {
            out.print("Invalid action");
        }
        
        pstmt.close();
        conn.close();
        
    } catch(Exception e) {
        try {
            if (conn != null) {
                conn.rollback();
            }
        } catch(SQLException se) {
            // Handle rollback exception
        }
        out.print("Error: " + e.getMessage());
    }
%>
