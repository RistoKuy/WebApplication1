<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%-- Admin Order Actions Handler --%>
<%
    // Check if user is admin
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isLoggedIn == null || !isLoggedIn || isAdmin == null || !isAdmin) {
        out.print("unauthorized");
        return;
    }

    String action = request.getParameter("action");
    
    if (action == null) {
        out.print("missing_parameters");
        return;
    }
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/web_enterprise";
        String dbUser = "root";
        String dbPassword = "";
        Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);
        
        if ("update_order_status".equals(action)) {
            String invoiceIdStr = request.getParameter("invoice_id");
            String orderIdStr = request.getParameter("order_id");
            String newStatus = request.getParameter("status");
            
            if (invoiceIdStr == null || orderIdStr == null || newStatus == null) {
                out.print("missing_parameters");
                return;
            }
            
            int invoiceId = Integer.parseInt(invoiceIdStr);
            int orderId = Integer.parseInt(orderIdStr);
            
            if (!newStatus.equals("pending") && !newStatus.equals("completed")) {
                out.print("invalid_status");
                return;
            }
            
            // Update both invoice and order tables
            conn.setAutoCommit(false); // Start transaction            try {
                // Update invoice table
                String sqlInvoice = "UPDATE `invoice` SET status_order = ? WHERE id_invoice = ?";
                PreparedStatement pstmtInvoice = conn.prepareStatement(sqlInvoice);
                pstmtInvoice.setString(1, newStatus);
                pstmtInvoice.setInt(2, invoiceId);
                
                int invoiceRowsAffected = pstmtInvoice.executeUpdate();
                pstmtInvoice.close();
                  // Get order details to find related orders in the same checkout session
                String getOrderSql = "SELECT o.firebase_uid, o.metode_pengiriman, o.metode_pembayaran, o.tgl_order FROM `order` o WHERE o.id_order = ?";
                PreparedStatement getOrderPstmt = conn.prepareStatement(getOrderSql);
                getOrderPstmt.setInt(1, orderId);
                ResultSet orderRs = getOrderPstmt.executeQuery();
                
                int totalOrdersUpdated = 0;
                if (orderRs.next()) {
                    String firebase_uid = orderRs.getString("firebase_uid");
                    String metodePengiriman = orderRs.getString("metode_pengiriman");
                    String metodePembayaran = orderRs.getString("metode_pembayaran");
                    java.sql.Timestamp orderTime = orderRs.getTimestamp("tgl_order");
                    
                    // Update ALL orders from the same checkout session
                    String updateRelatedOrdersSql = "UPDATE `order` SET status_order = ? WHERE firebase_uid = ? AND metode_pengiriman = ? AND metode_pembayaran = ? AND ABS(TIMESTAMPDIFF(SECOND, tgl_order, ?)) <= 300";
                    PreparedStatement updateRelatedOrdersPstmt = conn.prepareStatement(updateRelatedOrdersSql);
                    updateRelatedOrdersPstmt.setString(1, newStatus);
                    updateRelatedOrdersPstmt.setString(2, firebase_uid);
                    updateRelatedOrdersPstmt.setString(3, metodePengiriman);
                    updateRelatedOrdersPstmt.setString(4, metodePembayaran);
                    updateRelatedOrdersPstmt.setTimestamp(5, orderTime);
                    
                    totalOrdersUpdated = updateRelatedOrdersPstmt.executeUpdate();
                    updateRelatedOrdersPstmt.close();
                }
                orderRs.close();
                getOrderPstmt.close();
                
                if (invoiceRowsAffected > 0 && totalOrdersUpdated > 0) {
                    conn.commit(); // Commit transaction
                    out.print("success");
                } else {
                    conn.rollback(); // Rollback transaction
                    out.print("record_not_found");
                }
                
            } catch (Exception e) {
                conn.rollback(); // Rollback on error
                out.print("update_error: " + e.getMessage());
            } finally {
                conn.setAutoCommit(true); // Reset auto-commit
            }
            
        } else if ("update_invoice_status".equals(action)) {
            String invoiceIdStr = request.getParameter("invoice_id");
            String newStatus = request.getParameter("status");
            
            if (invoiceIdStr == null || newStatus == null) {
                out.print("missing_parameters");
                return;
            }
            
            int invoiceId = Integer.parseInt(invoiceIdStr);
            
            if (!newStatus.equals("pending") && !newStatus.equals("paid") && !newStatus.equals("cancelled")) {
                out.print("invalid_status");
                return;
            }
            
            String sql = "UPDATE `invoice` SET status_pembayaran = ? WHERE id_invoice = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, invoiceId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("success");
            } else {
                out.print("invoice_not_found");
            }
            
            pstmt.close();
            
        } else if ("delete_invoice".equals(action)) {
            String invoiceIdStr = request.getParameter("invoice_id");
            
            if (invoiceIdStr == null) {
                out.print("missing_parameters");
                return;
            }
            
            int invoiceId = Integer.parseInt(invoiceIdStr);
            
            String sql = "DELETE FROM `invoice` WHERE id_invoice = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, invoiceId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("success");
            } else {
                out.print("invoice_not_found");
            }
            
            pstmt.close();
            
        } else if ("update_status".equals(action)) {
            // Legacy order status update for backward compatibility
            String orderIdStr = request.getParameter("order_id");
            String newStatus = request.getParameter("status");
            
            if (orderIdStr == null || newStatus == null) {
                out.print("missing_parameters");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            if (!newStatus.equals("Pending") && !newStatus.equals("Completed")) {
                out.print("invalid_status");
                return;
            }
            
            String sql = "UPDATE `order` SET status_pembayaran = ? WHERE id_order = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, orderId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("success");
            } else {
                out.print("order_not_found");
            }
            
            pstmt.close();
            
        } else if ("delete_order".equals(action)) {
            // Legacy order deletion for backward compatibility
            String orderIdStr = request.getParameter("order_id");
            
            if (orderIdStr == null) {
                out.print("missing_parameters");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            String sql = "DELETE FROM `order` WHERE id_order = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("success");
            } else {
                out.print("order_not_found");
            }
            
            pstmt.close();
            
        } else {
            out.print("invalid_action");
        }
        
        conn.close();
        
    } catch (NumberFormatException e) {
        out.print("invalid_id");
    } catch (Exception e) {
        out.print("database_error: " + e.getMessage());
    }
%>
