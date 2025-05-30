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
            conn.setAutoCommit(false); // Start transaction
              try {
                // Update invoice table
                String sqlInvoice = "UPDATE `invoice` SET status_order = ? WHERE id_invoice = ?";
                PreparedStatement pstmtInvoice = conn.prepareStatement(sqlInvoice);
                pstmtInvoice.setString(1, newStatus);
                pstmtInvoice.setInt(2, invoiceId);
                
                int invoiceRowsAffected = pstmtInvoice.executeUpdate();
                pstmtInvoice.close();
                
                // Get reference order details to find all related orders from the same checkout session
                String referenceOrderSql = "SELECT firebase_uid, metode_pengiriman, metode_pembayaran, tgl_order FROM `order` WHERE id_order = ?";
                PreparedStatement refOrderPstmt = conn.prepareStatement(referenceOrderSql);
                refOrderPstmt.setInt(1, orderId);
                ResultSet refOrderRs = refOrderPstmt.executeQuery();
                
                int totalOrdersUpdated = 0;
                if (refOrderRs.next()) {
                    String refFirebaseUid = refOrderRs.getString("firebase_uid");
                    String refMetodePengiriman = refOrderRs.getString("metode_pengiriman");
                    String refMetodePembayaran = refOrderRs.getString("metode_pembayaran");
                    java.sql.Timestamp refTglOrder = refOrderRs.getTimestamp("tgl_order");
                    
                    // Update all orders from the same checkout session (within 60 seconds)
                    String updateRelatedOrdersSql = "UPDATE `order` SET status_order = ? WHERE firebase_uid = ? AND metode_pengiriman = ? AND metode_pembayaran = ? " +
                                                   "AND ABS(TIMESTAMPDIFF(SECOND, tgl_order, ?)) <= 60";
                    PreparedStatement updateRelatedOrdersPstmt = conn.prepareStatement(updateRelatedOrdersSql);
                    updateRelatedOrdersPstmt.setString(1, newStatus);
                    updateRelatedOrdersPstmt.setString(2, refFirebaseUid);
                    updateRelatedOrdersPstmt.setString(3, refMetodePengiriman);
                    updateRelatedOrdersPstmt.setString(4, refMetodePembayaran);
                    updateRelatedOrdersPstmt.setTimestamp(5, refTglOrder);
                    
                    totalOrdersUpdated = updateRelatedOrdersPstmt.executeUpdate();
                    updateRelatedOrdersPstmt.close();
                }
                refOrderRs.close();
                refOrderPstmt.close();
                
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
