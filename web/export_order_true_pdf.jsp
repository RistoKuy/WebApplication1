<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.DatabaseUtil"%>
<%-- PDF Export using PostScript approach --%>
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
        
        // Create PDF binary content using a basic PDF structure
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        // Basic PDF header
        String pdfHeader = "%PDF-1.4\n";
        String pdfContent = "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n";
        pdfContent += "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n";
        pdfContent += "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n";
        
        // Content stream
        StringBuilder contentStream = new StringBuilder();
        contentStream.append("BT\n");
        contentStream.append("/F1 12 Tf\n");
        contentStream.append("50 750 Td\n");
        contentStream.append("(ORDER INVOICE) Tj\n");
        contentStream.append("0 -20 Td\n");
        contentStream.append("(Order ID: #" + checkoutId + ") Tj\n");
        contentStream.append("0 -20 Td\n");
        contentStream.append("(Generated: " + sdf.format(new java.util.Date()) + ") Tj\n");
        contentStream.append("0 -30 Td\n");
        contentStream.append("(ORDER INFORMATION:) Tj\n");
        contentStream.append("0 -15 Td\n");
        contentStream.append("(Order Date: " + sdf.format(tglOrder) + ") Tj\n");
        contentStream.append("0 -15 Td\n");
        contentStream.append("(Status: " + statusOrder.toUpperCase() + ") Tj\n");
        contentStream.append("0 -15 Td\n");
        contentStream.append("(Recipient: " + namaPenerima + ") Tj\n");
        contentStream.append("0 -15 Td\n");
        contentStream.append("(Phone: " + noTelp + ") Tj\n");
        contentStream.append("0 -15 Td\n");
        contentStream.append("(Address: " + alamat + ") Tj\n");
        contentStream.append("0 -30 Td\n");
        contentStream.append("(ORDER ITEMS:) Tj\n");
        
        int yPos = -15;
        int itemNumber = 1;
        for (Map<String, Object> item : orderItems) {
            contentStream.append("0 " + yPos + " Td\n");
            contentStream.append("(" + itemNumber++ + ". " + (String)item.get("nama_brg") + ") Tj\n");
            yPos -= 12;
            contentStream.append("0 " + yPos + " Td\n");
            contentStream.append("(   Qty: " + item.get("jumlah") + " - Price: Rp " + String.format("%,.0f", (Double)item.get("total_harga")) + ") Tj\n");
            yPos -= 15;
        }
        
        contentStream.append("0 " + (yPos - 20) + " Td\n");
        contentStream.append("(GRAND TOTAL: Rp " + String.format("%,.0f", grandTotal) + ") Tj\n");
        contentStream.append("ET\n");
        
        String streamContent = contentStream.toString();
        int streamLength = streamContent.length();
        
        pdfContent += "4 0 obj\n<< /Length " + streamLength + " >>\nstream\n" + streamContent + "\nendstream\nendobj\n";
        pdfContent += "5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n";
        
        // Cross-reference table
        int xrefPos = pdfHeader.length() + pdfContent.length();
        String xref = "xref\n0 6\n";
        xref += "0000000000 65535 f \n";
        xref += String.format("%010d 00000 n \n", pdfHeader.length());
        xref += String.format("%010d 00000 n \n", pdfHeader.length() + pdfContent.indexOf("2 0 obj"));
        xref += String.format("%010d 00000 n \n", pdfHeader.length() + pdfContent.indexOf("3 0 obj"));
        xref += String.format("%010d 00000 n \n", pdfHeader.length() + pdfContent.indexOf("4 0 obj"));
        xref += String.format("%010d 00000 n \n", pdfHeader.length() + pdfContent.indexOf("5 0 obj"));
        
        String trailer = "trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n" + xrefPos + "\n%%EOF\n";
        
        // Set response headers for PDF download
        response.setContentType("application/pdf");
        String fileName = "Order_" + checkoutId + "_" + currentDateTime + ".pdf";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Write the PDF content
        response.getOutputStream().write((pdfHeader + pdfContent + xref + trailer).getBytes("ISO-8859-1"));
        response.getOutputStream().flush();
        
        out.clear();
        
    } catch (Exception e) {
        response.setContentType("text/html");
        String errorMsg = e.getMessage();
        if (errorMsg != null) {
            errorMsg = errorMsg.replace("'", "").replace("\"", "");
        } else {
            errorMsg = "PDF generation failed";
        }
        out.println("<script>alert('PDF generation error: " + errorMsg + "'); window.close();</script>");
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
