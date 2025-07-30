<%@page contentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" pageEncoding="UTF-8"%>
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
    
    // Set response headers for XLSX download
    String fileName = "Items_Report_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".xlsx";
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
        
        // Create ZIP structure for XLSX (which is essentially a ZIP file)
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ZipOutputStream zos = new ZipOutputStream(baos);
        
        // Add [Content_Types].xml
        zos.putNextEntry(new ZipEntry("[Content_Types].xml"));
        String contentTypes = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">" +
            "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>" +
            "<Default Extension=\"xml\" ContentType=\"application/xml\"/>" +
            "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>" +
            "<Override PartName=\"/xl/worksheets/sheet1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>" +
            "</Types>";
        zos.write(contentTypes.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Add _rels/.rels
        zos.putNextEntry(new ZipEntry("_rels/.rels"));
        String rels = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>" +
            "</Relationships>";
        zos.write(rels.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Add xl/_rels/workbook.xml.rels
        zos.putNextEntry(new ZipEntry("xl/_rels/workbook.xml.rels"));
        String workbookRels = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>" +
            "</Relationships>";
        zos.write(workbookRels.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Add xl/workbook.xml
        zos.putNextEntry(new ZipEntry("xl/workbook.xml"));
        String workbook = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
            "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">" +
            "<sheets><sheet name=\"Items Report\" sheetId=\"1\" r:id=\"rId1\"/></sheets>" +
            "</workbook>";
        zos.write(workbook.getBytes("UTF-8"));
        zos.closeEntry();
        
        // Build the worksheet data
        StringBuilder worksheetData = new StringBuilder();
        worksheetData.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
        worksheetData.append("<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
        worksheetData.append("<sheetData>");
        
        // Header rows
        worksheetData.append("<row r=\"1\">");
        worksheetData.append("<c r=\"A1\" t=\"inlineStr\"><is><t>ITEM MANAGEMENT REPORT</t></is></c>");
        worksheetData.append("</row>");
        
        worksheetData.append("<row r=\"2\">");
        worksheetData.append("<c r=\"A2\" t=\"inlineStr\"><is><t>Generated on: ")
                     .append(new SimpleDateFormat("dd MMMM yyyy HH:mm:ss").format(new Date()))
                     .append("</t></is></c>");
        worksheetData.append("</row>");
        
        worksheetData.append("<row r=\"3\"></row>"); // Empty row
        
        // Column headers
        worksheetData.append("<row r=\"4\">");
        worksheetData.append("<c r=\"A4\" t=\"inlineStr\"><is><t>No</t></is></c>");
        worksheetData.append("<c r=\"B4\" t=\"inlineStr\"><is><t>Item Name</t></is></c>");
        worksheetData.append("<c r=\"C4\" t=\"inlineStr\"><is><t>Description</t></is></c>");
        worksheetData.append("<c r=\"D4\" t=\"inlineStr\"><is><t>Stock</t></is></c>");
        worksheetData.append("<c r=\"E4\" t=\"inlineStr\"><is><t>Price (IDR)</t></is></c>");
        worksheetData.append("</row>");
        
        // Data rows
        String sql = "SELECT * FROM item ORDER BY id_brg";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        int rowNum = 5;
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
            
            worksheetData.append("<row r=\"").append(rowNum).append("\">");
            worksheetData.append("<c r=\"A").append(rowNum).append("\"><v>").append(itemCount).append("</v></c>");
            worksheetData.append("<c r=\"B").append(rowNum).append("\" t=\"inlineStr\"><is><t>").append(nama_brg).append("</t></is></c>");
            worksheetData.append("<c r=\"C").append(rowNum).append("\" t=\"inlineStr\"><is><t>").append(deskripsi).append("</t></is></c>");
            worksheetData.append("<c r=\"D").append(rowNum).append("\"><v>").append(stok).append("</v></c>");
            worksheetData.append("<c r=\"E").append(rowNum).append("\"><v>").append(harga).append("</v></c>");
            worksheetData.append("</row>");
            
            rowNum++;
        }
        
        // Summary section
        rowNum += 2; // Skip a row
        worksheetData.append("<row r=\"").append(rowNum).append("\">");
        worksheetData.append("<c r=\"A").append(rowNum).append("\" t=\"inlineStr\"><is><t>SUMMARY REPORT</t></is></c>");
        worksheetData.append("</row>");
        
        rowNum++;
        worksheetData.append("<row r=\"").append(rowNum).append("\">");
        worksheetData.append("<c r=\"A").append(rowNum).append("\" t=\"inlineStr\"><is><t>Total Number of Items:</t></is></c>");
        worksheetData.append("<c r=\"B").append(rowNum).append("\"><v>").append(itemCount).append("</v></c>");
        worksheetData.append("</row>");
        
        rowNum++;
        worksheetData.append("<row r=\"").append(rowNum).append("\">");
        worksheetData.append("<c r=\"A").append(rowNum).append("\" t=\"inlineStr\"><is><t>Total Stock Quantity:</t></is></c>");
        worksheetData.append("<c r=\"B").append(rowNum).append("\"><v>").append(totalItems).append("</v></c>");
        worksheetData.append("</row>");
        
        rowNum++;
        worksheetData.append("<row r=\"").append(rowNum).append("\">");
        worksheetData.append("<c r=\"A").append(rowNum).append("\" t=\"inlineStr\"><is><t>Total Inventory Value:</t></is></c>");
        worksheetData.append("<c r=\"B").append(rowNum).append("\"><v>").append(String.format("%.0f", totalValue)).append("</v></c>");
        worksheetData.append("</row>");
        
        if (itemCount > 0) {
            rowNum++;
            worksheetData.append("<row r=\"").append(rowNum).append("\">");
            worksheetData.append("<c r=\"A").append(rowNum).append("\" t=\"inlineStr\"><is><t>Average Price per Item:</t></is></c>");
            worksheetData.append("<c r=\"B").append(rowNum).append("\"><v>").append(String.format("%.0f", totalValue / itemCount)).append("</v></c>");
            worksheetData.append("</row>");
        }
        
        worksheetData.append("</sheetData>");
        worksheetData.append("</worksheet>");
        
        // Add xl/worksheets/sheet1.xml
        zos.putNextEntry(new ZipEntry("xl/worksheets/sheet1.xml"));
        zos.write(worksheetData.toString().getBytes("UTF-8"));
        zos.closeEntry();
        
        zos.close();
        
        // Write the ZIP file to response
        byte[] xlsxData = baos.toByteArray();
        response.getOutputStream().write(xlsxData);
        response.getOutputStream().flush();
        
    } catch (Exception e) {
        response.setContentType("text/html");
        out.println("Error generating XLSX: " + e.getMessage());
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
