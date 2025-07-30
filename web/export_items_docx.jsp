<%@page contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.zip.*"%>
<%
    // Check if user is logged in
    Boolean isLoggedIn = (Boolean) session.getAttribute("loggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Set response headers for DOCX download
    String fileName = "Items_Report_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".docx";
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Load the database driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Connect to the database
        String url = "jdbc:mysql://localhost:3306/web_enterprise";
        String dbUser = "root";
        String dbPassword = "";
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        
        // Clear any existing output
        out.clear();
        
        // Create ZIP structure for DOCX (which is essentially a ZIP file)
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ZipOutputStream zos = new ZipOutputStream(baos);
        
        // Add [Content_Types].xml
        zos.putNextEntry(new ZipEntry("[Content_Types].xml"));
        String contentTypes = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">" +
            "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>" +
            "<Default Extension=\"xml\" ContentType=\"application/xml\"/>" +
            "<Override PartName=\"/word/document.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml\"/>" +
            "</Types>";
        zos.write(contentTypes.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Add _rels/.rels
        zos.putNextEntry(new ZipEntry("_rels/.rels"));
        String rels = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"word/document.xml\"/>" +
            "</Relationships>";
        zos.write(rels.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Add word/_rels/document.xml.rels
        zos.putNextEntry(new ZipEntry("word/_rels/document.xml.rels"));
        String documentRels = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
            "</Relationships>";
        zos.write(documentRels.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Build the document content
        StringBuilder documentContent = new StringBuilder();
        documentContent.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
        documentContent.append("<w:document xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">");
        documentContent.append("<w:body>");
        
        // Title
        documentContent.append("<w:p>");
        documentContent.append("<w:pPr><w:jc w:val=\"center\"/></w:pPr>");
        documentContent.append("<w:r><w:rPr><w:b/><w:sz w:val=\"28\"/></w:rPr>");
        documentContent.append("<w:t>ITEM MANAGEMENT REPORT</w:t></w:r>");
        documentContent.append("</w:p>");
        
        // Date
        documentContent.append("<w:p>");
        documentContent.append("<w:pPr><w:jc w:val=\"center\"/></w:pPr>");
        documentContent.append("<w:r><w:rPr><w:sz w:val=\"20\"/></w:rPr>");
        documentContent.append("<w:t>Generated on: ")
                       .append(new SimpleDateFormat("dd MMMM yyyy HH:mm:ss").format(new Date()))
                       .append("</w:t></w:r>");
        documentContent.append("</w:p>");
        
        // Empty paragraph
        documentContent.append("<w:p/>");
        
        // Table start
        documentContent.append("<w:tbl>");
        documentContent.append("<w:tblPr>");
        documentContent.append("<w:tblStyle w:val=\"TableGrid\"/>");
        documentContent.append("<w:tblW w:w=\"0\" w:type=\"auto\"/>");
        documentContent.append("</w:tblPr>");
        
        // Table headers
        documentContent.append("<w:tr>");
        documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"4472C4\"/></w:tcPr>");
        documentContent.append("<w:p><w:r><w:rPr><w:b/><w:color w:val=\"FFFFFF\"/></w:rPr><w:t>No</w:t></w:r></w:p></w:tc>");
        documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"4472C4\"/></w:tcPr>");
        documentContent.append("<w:p><w:r><w:rPr><w:b/><w:color w:val=\"FFFFFF\"/></w:rPr><w:t>Item Name</w:t></w:r></w:p></w:tc>");
        documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"4472C4\"/></w:tcPr>");
        documentContent.append("<w:p><w:r><w:rPr><w:b/><w:color w:val=\"FFFFFF\"/></w:rPr><w:t>Description</w:t></w:r></w:p></w:tc>");
        documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"4472C4\"/></w:tcPr>");
        documentContent.append("<w:p><w:r><w:rPr><w:b/><w:color w:val=\"FFFFFF\"/></w:rPr><w:t>Stock</w:t></w:r></w:p></w:tc>");
        documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"4472C4\"/></w:tcPr>");
        documentContent.append("<w:p><w:r><w:rPr><w:b/><w:color w:val=\"FFFFFF\"/></w:rPr><w:t>Price (IDR)</w:t></w:r></w:p></w:tc>");
        documentContent.append("</w:tr>");
        
        // Data rows
        String sql = "SELECT * FROM item ORDER BY id_brg";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        int itemNum = 1;
        int totalItems = 0;
        double totalValue = 0;
        int itemCount = 0;
        
        while(rs.next()) {
            int id_brg = rs.getInt("id_brg");
            String nama_brg = rs.getString("nama_brg");
            String deskripsi = rs.getString("deskripsi");
            String harga = rs.getString("harga");
            int stok = rs.getInt("stok");
            
            // Handle null values and clean data for XML
            if (nama_brg == null) nama_brg = "";
            if (deskripsi == null) deskripsi = "";
            if (harga == null) harga = "0";
            
            // Clean strings for XML (escape special characters)
            nama_brg = nama_brg.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");
            deskripsi = deskripsi.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");
            
            // Calculate totals
            totalItems += stok;
            double hargaValue = 0;
            try {
                hargaValue = Double.parseDouble(harga);
            } catch (NumberFormatException e) {
                hargaValue = 0;
            }
            totalValue += (hargaValue * stok);
            itemCount++;
            
            // Format price
            String hargaFormatted = "Rp " + String.format("%,d", (long)hargaValue).replace(',', '.');
            
            // Table row
            String bgColor = (itemNum % 2 == 0) ? "F2F2F2" : "FFFFFF";
            documentContent.append("<w:tr>");
            documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"").append(bgColor).append("\"/></w:tcPr>");
            documentContent.append("<w:p><w:r><w:t>").append(itemNum).append("</w:t></w:r></w:p></w:tc>");
            documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"").append(bgColor).append("\"/></w:tcPr>");
            documentContent.append("<w:p><w:r><w:t>").append(nama_brg).append("</w:t></w:r></w:p></w:tc>");
            documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"").append(bgColor).append("\"/></w:tcPr>");
            documentContent.append("<w:p><w:r><w:t>").append(deskripsi).append("</w:t></w:r></w:p></w:tc>");
            documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"").append(bgColor).append("\"/></w:tcPr>");
            documentContent.append("<w:p><w:r><w:t>").append(stok).append("</w:t></w:r></w:p></w:tc>");
            documentContent.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"").append(bgColor).append("\"/></w:tcPr>");
            documentContent.append("<w:p><w:r><w:t>").append(hargaFormatted).append("</w:t></w:r></w:p></w:tc>");
            documentContent.append("</w:tr>");
            
            itemNum++;
        }
        
        documentContent.append("</w:tbl>");
        
        // Summary section
        documentContent.append("<w:p/>");
        documentContent.append("<w:p>");
        documentContent.append("<w:pPr><w:jc w:val=\"center\"/></w:pPr>");
        documentContent.append("<w:r><w:rPr><w:b/><w:sz w:val=\"24\"/></w:rPr>");
        documentContent.append("<w:t>SUMMARY REPORT</w:t></w:r>");
        documentContent.append("</w:p>");
        
        documentContent.append("<w:p>");
        documentContent.append("<w:r><w:rPr><w:b/></w:rPr><w:t>Total Number of Items: </w:t></w:r>");
        documentContent.append("<w:r><w:t>").append(itemCount).append("</w:t></w:r>");
        documentContent.append("</w:p>");
        
        documentContent.append("<w:p>");
        documentContent.append("<w:r><w:rPr><w:b/></w:rPr><w:t>Total Stock Quantity: </w:t></w:r>");
        documentContent.append("<w:r><w:t>").append(totalItems).append(" units</w:t></w:r>");
        documentContent.append("</w:p>");
        
        documentContent.append("<w:p>");
        documentContent.append("<w:r><w:rPr><w:b/></w:rPr><w:t>Total Inventory Value: </w:t></w:r>");
        documentContent.append("<w:r><w:t>Rp ").append(String.format("%,d", (long)totalValue).replace(',', '.')).append("</w:t></w:r>");
        documentContent.append("</w:p>");
        
        if (itemCount > 0) {
            documentContent.append("<w:p>");
            documentContent.append("<w:r><w:rPr><w:b/></w:rPr><w:t>Average Price per Item: </w:t></w:r>");
            documentContent.append("<w:r><w:t>Rp ").append(String.format("%,d", (long)(totalValue / itemCount)).replace(',', '.')).append("</w:t></w:r>");
            documentContent.append("</w:p>");
        }
        
        // Footer
        documentContent.append("<w:p/>");
        documentContent.append("<w:p>");
        documentContent.append("<w:pPr><w:jc w:val=\"center\"/></w:pPr>");
        documentContent.append("<w:r><w:rPr><w:sz w:val=\"18\"/><w:color w:val=\"666666\"/></w:rPr>");
        documentContent.append("<w:t>Report generated by Item Management System - ")
                       .append(new SimpleDateFormat("EEEE, dd MMMM yyyy 'at' HH:mm:ss").format(new Date()))
                       .append("</w:t></w:r>");
        documentContent.append("</w:p>");
        
        documentContent.append("</w:body>");
        documentContent.append("</w:document>");
        
        // Add word/document.xml
        zos.putNextEntry(new ZipEntry("word/document.xml"));
        zos.write(documentContent.toString().getBytes("UTF-8"));
        zos.closeEntry();
        
        zos.close();
        
        // Write the ZIP file to response
        byte[] docxData = baos.toByteArray();
        response.getOutputStream().write(docxData);
        response.getOutputStream().flush();
        
    } catch (Exception e) {
        response.setContentType("text/html");
        out.println("Error generating DOCX: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException e) {
            // Do nothing
        }
    }
%>
