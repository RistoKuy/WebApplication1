<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Output Data Mahasiswa</title>
    </head>
    <body>
        <center>
            <h1>Data Mahasiswa</h1>
            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <th>NIM</th>
                    <td><%= request.getParameter("nim") %></td>
                </tr>
                <tr>
                    <th>Nama</th>
                    <td><%= request.getParameter("nama") %></td>
                </tr>
                <tr>
                    <th>Jenis Kelamin</th>
                    <td><%= request.getParameter("jenis_kelamin") %></td>
                </tr>
                <tr>
                    <th>Tanggal Lahir</th>
                    <td>
                        <%= request.getParameter("tanggal") %> 
                        <%= request.getParameter("bulan") %> 
                        <%= request.getParameter("tahun") %>
                    </td>
                </tr>
                <tr>
                    <th>Tempat Lahir</th>
                    <td><%= request.getParameter("tempat_lahir") %></td>
                </tr>
                <tr>
                    <th>Jurusan</th>
                    <td><%= request.getParameter("jurusan") %></td>
                </tr>
                <tr>
                    <th>Tahun Masuk</th>
                    <td><%= request.getParameter("tahun_masuk") %></td>
                </tr>
            </table>
        </center>
    </body>
</html>
