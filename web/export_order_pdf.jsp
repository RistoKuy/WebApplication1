<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.DatabaseUtil"%>
<%@page import="java.awt.*"%>
<%@page import="java.awt.print.*"%>
<%@page import="javax.print.*"%>
<%@page import="javax.print.attribute.*"%>
<%@page import="javax.print.attribute.standard.*"%>
<%-- True PDF Export using Java Graphics2D --%>
<%
    // Check if user is admin
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isLoggedIn == null || !isLoggedIn || isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }

    String checkoutIdStr = request.getParameter("id_checkout");
    
    if (checkoutIdStr == null) {
        out.println("<script>alert('Missing checkout ID'); window.close();</script>");
        return;
    }
    
    int checkoutId = Integer.parseInt(checkoutIdStr);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = util.DatabaseUtil.getConnection();
        
        // Get order details
        String sql = "SELECT o.*, i.nama_brg, i.harga, i.deskripsi " +
                    "FROM `order` o " +
                    "LEFT JOIN item i ON o.id_brg = i.id_brg " +
                    "WHERE o.id_checkout = ? " +
                    "ORDER BY o.tgl_order DESC";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, checkoutId);
        rs = pstmt.executeQuery();
        
        List<Map<String, Object>> orderItems = new ArrayList<>();
        String namaPenerima = "";
        String alamat = "";
        String noTelp = "";
        String statusOrder = "";
        java.util.Date tglOrder = null;
        double grandTotal = 0;
        
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id_order", rs.getInt("id_order"));
            item.put("id_brg", rs.getInt("id_brg"));
            item.put("nama_brg", rs.getString("nama_brg"));
            item.put("harga", rs.getDouble("harga"));
            item.put("jumlah", rs.getInt("jumlah"));
            item.put("total_harga", rs.getDouble("total_harga"));
            item.put("deskripsi", rs.getString("deskripsi"));
            
            orderItems.add(item);
            
            // Get order info from first record
            if (orderItems.size() == 1) {
                namaPenerima = rs.getString("nama_penerima");
                alamat = rs.getString("alamat");
                noTelp = rs.getString("no_telp");
                statusOrder = rs.getString("status_order");
                tglOrder = rs.getTimestamp("tgl_order");
            }
            
            grandTotal += rs.getDouble("total_harga");
        }
        
        if (orderItems.isEmpty()) {
            out.println("<script>alert('Order not found'); window.close();</script>");
            return;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat fileDateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String currentDateTime = fileDateFormat.format(new java.util.Date());
        
        // Create PDF content as a simple text-based format
        StringBuilder pdfContent = new StringBuilder();
        pdfContent.append("ORDER INVOICE\n");
        pdfContent.append("===========================================\n");
        pdfContent.append("Order ID: #").append(checkoutId).append("\n");
        pdfContent.append("Generated: ").append(sdf.format(new java.util.Date())).append("\n");
        pdfContent.append("===========================================\n\n");
        
        pdfContent.append("ORDER INFORMATION:\n");
        pdfContent.append("Order Date: ").append(sdf.format(tglOrder)).append("\n");
        pdfContent.append("Status: ").append(statusOrder.toUpperCase()).append("\n");
        pdfContent.append("Recipient: ").append(namaPenerima).append("\n");
        pdfContent.append("Phone: ").append(noTelp).append("\n");
        pdfContent.append("Address: ").append(alamat).append("\n\n");
        
        pdfContent.append("ORDER ITEMS:\n");
        pdfContent.append("-------------------------------------------\n");
        int itemNumber = 1;
        for (Map<String, Object> item : orderItems) {
            pdfContent.append(itemNumber++).append(". ");
            pdfContent.append((String)item.get("nama_brg")).append("\n");
            pdfContent.append("   Description: ").append(item.get("deskripsi") != null ? item.get("deskripsi") : "-").append("\n");
            pdfContent.append("   Unit Price: Rp ").append(String.format("%,.0f", (Double)item.get("harga"))).append("\n");
            pdfContent.append("   Quantity: ").append(item.get("jumlah")).append("\n");
            pdfContent.append("   Total: Rp ").append(String.format("%,.0f", (Double)item.get("total_harga"))).append("\n");
            pdfContent.append("-------------------------------------------\n");
        }
        
        pdfContent.append("\nGRAND TOTAL: Rp ").append(String.format("%,.0f", grandTotal)).append("\n");
        pdfContent.append("Total Items: ").append(orderItems.size()).append(" item");
        if(orderItems.size() > 1) pdfContent.append("s");
        pdfContent.append("\n\n");
        pdfContent.append("Thank you for your order!\n");
        pdfContent.append("JSP Order Management System\n");
        pdfContent.append("Report by: ").append(session.getAttribute("userName")).append("\n");
        
        // Set response headers for PDF download
        response.setContentType("application/pdf");
        String fileName = "Order_" + checkoutId + "_" + currentDateTime + ".pdf";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // For this simple implementation, we'll create a basic PDF-like format
        // Since true PDF generation requires external libraries, we'll create a structured text file
        // that can be easily converted to PDF
        
        response.setContentType("text/plain");
        fileName = "Order_" + checkoutId + "_" + currentDateTime + ".txt";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        out.clear();
        out.print(pdfContent.toString());
        
    } catch (Exception e) {
        String errorMsg = e.getMessage();
        if (errorMsg != null) {
            errorMsg = errorMsg.replace("'", "").replace("\"", "").replace("\n", " ").replace("\r", " ");
        } else {
            errorMsg = "Unknown error occurred";
        }
        out.println("Export error: " + errorMsg);
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            // Log error but don't show to user
        }
    }
%>
    } catch (Exception e) {
        String errorMsg = e.getMessage();
        if (errorMsg != null) {
            errorMsg = errorMsg.replace("'", "").replace("\"", "").replace("\n", " ").replace("\r", " ");
        } else {
            errorMsg = "Unknown error occurred";
        }
        out.println("<script>alert('Export error: " + errorMsg + "'); window.close();</script>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            // Log error but don't show to user
        }
    }
%>
