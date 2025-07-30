<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.DatabaseUtil"%>
<%-- Order Export Handler - Supports PDF and JSON formats --%>
<%
    // Check if user is admin
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isLoggedIn == null || !isLoggedIn || isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }

    String action = request.getParameter("action");
    String checkoutIdStr = request.getParameter("id_checkout");
    
    if (action == null || checkoutIdStr == null) {
        out.println("<script>alert('Missing parameters'); window.close();</script>");
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
        
        if ("pdf".equals(action)) {
            // Export as PDF (HTML to PDF approach)
            response.setContentType("text/html");
            // Don't set PDF download headers, just display HTML that can be printed to PDF
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Order Report #<%= checkoutId %></title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background: white; 
            color: black;
            line-height: 1.4;
        }
        .header { 
            text-align: center; 
            border-bottom: 2px solid #333; 
            padding-bottom: 20px; 
            margin-bottom: 30px; 
        }
        .order-info { 
            margin-bottom: 30px; 
            background: #f8f9fa; 
            padding: 15px; 
            border-radius: 8px; 
        }
        .order-info table { 
            width: 100%; 
            border-collapse: collapse; 
        }
        .order-info td { 
            padding: 8px; 
            border: 1px solid #ddd; 
        }
        .items-table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-bottom: 20px; 
        }
        .items-table th, .items-table td { 
            border: 1px solid #333; 
            padding: 10px; 
            text-align: left; 
        }
        .items-table th { 
            background-color: #f0f0f0; 
            font-weight: bold; 
        }
        .total { 
            text-align: right; 
            font-size: 18px; 
            font-weight: bold; 
            margin-top: 20px; 
        }
        .footer { 
            margin-top: 40px; 
            text-align: center; 
            font-size: 12px; 
            color: #666; 
        }
        .action-buttons {
            text-align: center;
            margin: 20px 0;
            padding: 20px;
            background: #e9ecef;
            border-radius: 8px;
        }
        .btn {
            padding: 10px 20px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary { background: #007bff; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-success { background: #28a745; color: white; }
        @media print {
            body { margin: 0; }
            .no-print, .action-buttons { display: none !important; }
        }
    </style>
    <script>
        function printPDF() {
            window.print();
        }
        
        function downloadPDF() {
            // This will trigger the browser's "Save as PDF" option
            window.print();
        }
        
        // Auto-focus for better user experience
        window.onload = function() {
            document.body.focus();
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>ORDER REPORT</h1>
        <h2>Order ID: #<%= checkoutId %></h2>
        <p>Generated on: <%= sdf.format(new java.util.Date()) %></p>
    </div>
    
    <div class="order-info">
        <h3>Order Information</h3>
        <table>
            <tr>
                <td><strong>Order Date:</strong></td>
                <td><%= sdf.format(tglOrder) %></td>
                <td><strong>Status:</strong></td>
                <td><%= statusOrder.toUpperCase() %></td>
            </tr>
            <tr>
                <td><strong>Recipient Name:</strong></td>
                <td><%= namaPenerima %></td>
                <td><strong>Phone:</strong></td>
                <td><%= noTelp %></td>
            </tr>
            <tr>
                <td colspan="4"><strong>Address:</strong> <%= alamat %></td>
            </tr>
        </table>
    </div>
    
    <h3>Order Items</h3>
    <table class="items-table">
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Description</th>
                <th>Unit Price</th>
                <th>Quantity</th>
                <th>Total Price</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, Object> item : orderItems) { %>
            <tr>
                <td><%= item.get("nama_brg") %></td>
                <td><%= item.get("deskripsi") != null ? item.get("deskripsi") : "-" %></td>
                <td>Rp <%= String.format("%,.0f", (Double)item.get("harga")) %></td>
                <td><%= item.get("jumlah") %></td>
                <td>Rp <%= String.format("%,.0f", (Double)item.get("total_harga")) %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    
    <div class="total">
        <strong>Grand Total: Rp <%= String.format("%,.0f", grandTotal) %></strong>
    </div>
    
    <div class="footer">
        <p>This is an automatically generated report from Order Management System</p>
        <p>Report generated on <%= sdf.format(new java.util.Date()) %></p>
    </div>
    
    <div class="action-buttons no-print">
        <h4>Export Options</h4>
        <p>Choose how you want to save this order report:</p>
        <button onclick="printPDF()" class="btn btn-primary">🖨️ Print / Save as PDF</button>
        <button onclick="window.close()" class="btn btn-secondary">❌ Close Window</button>
        <br><br>
        <small>
            <strong>How to save as PDF:</strong><br>
            1. Click "Print / Save as PDF" button above<br>
            2. In the print dialog, select "Save as PDF" or "Microsoft Print to PDF"<br>
            3. Choose your desired location and filename<br>
            4. Click Save
        </small>
    </div>
</body>
</html>
<%
        } else if ("json".equals(action)) {
            // Export as JSON
            response.setContentType("application/json");
            String fileName = "Order_" + checkoutId + "_" + currentDateTime + ".json";
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            
            out.clear();
            
            // Build JSON response
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{\n");
            jsonBuilder.append("  \"order_id\": ").append(checkoutId).append(",\n");
            jsonBuilder.append("  \"order_date\": \"").append(sdf.format(tglOrder)).append("\",\n");
            jsonBuilder.append("  \"status\": \"").append(statusOrder).append("\",\n");
            jsonBuilder.append("  \"recipient_info\": {\n");
            jsonBuilder.append("    \"name\": \"").append(namaPenerima.replace("\"", "\\\"")).append("\",\n");
            jsonBuilder.append("    \"address\": \"").append(alamat.replace("\"", "\\\"")).append("\",\n");
            jsonBuilder.append("    \"phone\": \"").append(noTelp).append("\"\n");
            jsonBuilder.append("  },\n");
            jsonBuilder.append("  \"items\": [\n");
            
            for (int i = 0; i < orderItems.size(); i++) {
                Map<String, Object> item = orderItems.get(i);
                jsonBuilder.append("    {\n");
                jsonBuilder.append("      \"item_id\": ").append(item.get("id_brg")).append(",\n");
                jsonBuilder.append("      \"item_name\": \"").append(((String)item.get("nama_brg")).replace("\"", "\\\"")).append("\",\n");
                jsonBuilder.append("      \"description\": \"").append(item.get("deskripsi") != null ? ((String)item.get("deskripsi")).replace("\"", "\\\"") : "").append("\",\n");
                jsonBuilder.append("      \"unit_price\": ").append(item.get("harga")).append(",\n");
                jsonBuilder.append("      \"quantity\": ").append(item.get("jumlah")).append(",\n");
                jsonBuilder.append("      \"total_price\": ").append(item.get("total_harga")).append("\n");
                jsonBuilder.append("    }");
                if (i < orderItems.size() - 1) {
                    jsonBuilder.append(",");
                }
                jsonBuilder.append("\n");
            }
            
            jsonBuilder.append("  ],\n");
            jsonBuilder.append("  \"grand_total\": ").append(grandTotal).append(",\n");
            jsonBuilder.append("  \"export_timestamp\": \"").append(sdf.format(new java.util.Date())).append("\",\n");
            jsonBuilder.append("  \"export_by\": \"").append(session.getAttribute("userName")).append("\"\n");
            jsonBuilder.append("}\n");
            
            out.print(jsonBuilder.toString());
        } else {
            out.println("<script>alert('Invalid export format'); window.close();</script>");
        }
        
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
