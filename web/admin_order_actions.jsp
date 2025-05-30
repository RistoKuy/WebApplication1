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
          if ("update_checkout_status".equals(action)) {
            String checkoutIdStr = request.getParameter("id_checkout");
            String newStatus = request.getParameter("status");
            
            if (checkoutIdStr == null || newStatus == null) {
                out.print("missing_parameters");
                return;
            }
            
            int checkoutId = Integer.parseInt(checkoutIdStr);
            
            if (!newStatus.equals("pending") && !newStatus.equals("completed") && !newStatus.equals("cancelled")) {
                out.print("invalid_status");
                return;
            }
            
            // Update status for all orders in this checkout
            String sql = "UPDATE `order` SET status_order = ? WHERE id_checkout = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, checkoutId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("success");
            } else {
                out.print("no_orders_found");
            }
            
            pstmt.close();
            
        } else if ("delete_checkout".equals(action)) {
            String checkoutIdStr = request.getParameter("id_checkout");
            
            if (checkoutIdStr == null) {
                out.print("missing_parameters");
                return;
            }
            
            int checkoutId = Integer.parseInt(checkoutIdStr);
            
            // Start transaction to handle stock restoration
            conn.setAutoCommit(false);
            
            try {
                // First get all items in this checkout to restore stock
                String getItemsSql = "SELECT id_brg, jumlah FROM `order` WHERE id_checkout = ?";
                PreparedStatement getItemsPstmt = conn.prepareStatement(getItemsSql);
                getItemsPstmt.setInt(1, checkoutId);
                ResultSet itemsRs = getItemsPstmt.executeQuery();
                
                // Restore stock for each item
                while (itemsRs.next()) {
                    int itemId = itemsRs.getInt("id_brg");
                    int quantity = itemsRs.getInt("jumlah");
                    
                    String restoreStockSql = "UPDATE item SET stok = stok + ? WHERE id_brg = ?";
                    PreparedStatement restoreStockPstmt = conn.prepareStatement(restoreStockSql);
                    restoreStockPstmt.setInt(1, quantity);
                    restoreStockPstmt.setInt(2, itemId);
                    restoreStockPstmt.executeUpdate();
                    restoreStockPstmt.close();
                }
                
                itemsRs.close();
                getItemsPstmt.close();
                
                // Delete all orders in this checkout
                String deleteOrdersSql = "DELETE FROM `order` WHERE id_checkout = ?";
                PreparedStatement deleteOrdersPstmt = conn.prepareStatement(deleteOrdersSql);
                deleteOrdersPstmt.setInt(1, checkoutId);
                int deletedRows = deleteOrdersPstmt.executeUpdate();
                deleteOrdersPstmt.close();
                
                if (deletedRows > 0) {
                    conn.commit();
                    out.print("success");
                } else {
                    conn.rollback();
                    out.print("no_orders_found");
                }
                
            } catch (Exception e) {
                conn.rollback();
                out.print("delete_error: " + e.getMessage());
            }
            
        } else if ("update_order_status".equals(action)) {
            // Keep legacy support for individual order updates
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
