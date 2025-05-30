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
            String orderIdStr = request.getParameter("order_id");
            String newStatus = request.getParameter("status");
            
            if (orderIdStr == null || newStatus == null) {
                out.print("missing_parameters");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            if (!newStatus.equals("pending") && !newStatus.equals("completed") && !newStatus.equals("cancelled")) {
                out.print("invalid_status");
                return;
            }
            
            // Start transaction
            conn.setAutoCommit(false);
            
            try {
                // Get order details to find related orders in the same checkout session
                String getOrderSql = "SELECT firebase_uid, metode_pengiriman, metode_pembayaran, tgl_order FROM `order` WHERE id_order = ?";
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
                
                if (totalOrdersUpdated > 0) {
                    conn.commit();
                    out.print("success");
                } else {
                    conn.rollback();
                    out.print("record_not_found");
                }
                
            } catch (Exception e) {
                conn.rollback();
                out.print("update_error: " + e.getMessage());
            } finally {
                conn.setAutoCommit(true);
            }
            
        } else if ("update_status".equals(action)) {
            String orderIdStr = request.getParameter("order_id");
            String newStatus = request.getParameter("status");
            
            if (orderIdStr == null || newStatus == null) {
                out.print("missing_parameters");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            if (!newStatus.equals("pending") && !newStatus.equals("completed") && !newStatus.equals("cancelled")) {
                out.print("invalid_status");
                return;
            }
            
            String sql = "UPDATE `order` SET status_order = ? WHERE id_order = ?";
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
            String orderIdStr = request.getParameter("order_id");
            
            if (orderIdStr == null) {
                out.print("missing_parameters");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            // Start transaction to handle stock restoration
            conn.setAutoCommit(false);
            
            try {
                // Get order details before deletion to restore stock
                String getOrderDetailsSql = "SELECT id_brg, jumlah FROM `order` WHERE id_order = ?";
                PreparedStatement getDetailsPstmt = conn.prepareStatement(getOrderDetailsSql);
                getDetailsPstmt.setInt(1, orderId);
                ResultSet detailsRs = getDetailsPstmt.executeQuery();
                
                if (detailsRs.next()) {
                    int itemId = detailsRs.getInt("id_brg");
                    int quantity = detailsRs.getInt("jumlah");
                    
                    // Restore stock
                    String restoreStockSql = "UPDATE item SET stok = stok + ? WHERE id_brg = ?";
                    PreparedStatement stockPstmt = conn.prepareStatement(restoreStockSql);
                    stockPstmt.setInt(1, quantity);
                    stockPstmt.setInt(2, itemId);
                    stockPstmt.executeUpdate();
                    stockPstmt.close();
                    
                    // Delete the order
                    String deleteOrderSql = "DELETE FROM `order` WHERE id_order = ?";
                    PreparedStatement deletePstmt = conn.prepareStatement(deleteOrderSql);
                    deletePstmt.setInt(1, orderId);
                    int rowsAffected = deletePstmt.executeUpdate();
                    deletePstmt.close();
                    
                    if (rowsAffected > 0) {
                        conn.commit();
                        out.print("success");
                    } else {
                        conn.rollback();
                        out.print("order_not_found");
                    }
                } else {
                    conn.rollback();
                    out.print("order_not_found");
                }
                
                detailsRs.close();
                getDetailsPstmt.close();
                
            } catch (Exception e) {
                conn.rollback();
                out.print("delete_error: " + e.getMessage());
            } finally {
                conn.setAutoCommit(true);
            }
            
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
