<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Form Input Data Mahasiswa</title>
    </head>
    <body>
        <center>
            <h1>Form Input Data Mahasiswa</h1>
            <form action="output.jsp" method="post">
                <table>
                    <tr>
                        <td>NIM:</td>
                        <td><input type="text" name="nim" required></td>
                    </tr>
                    <tr>
                        <td>Nama:</td>
                        <td><input type="text" name="nama" required></td>
                    </tr>
                    <tr>
                        <td>Jenis Kelamin:</td>
                        <td>
                            <input type="radio" name="jenis_kelamin" value="Laki Laki" required> Laki Laki
                            <input type="radio" name="jenis_kelamin" value="Perempuan" required> Perempuan
                        </td>
                    </tr>
                    <tr>
                        <td>Tanggal Lahir:</td>
                        <td>
                            <select name="tanggal" required>
                                <!-- Options for dates -->
                                <% for (int i = 1; i <= 31; i++) { %>
                                    <option value="<%= i %>"><%= i %></option>
                                <% } %>
                            </select>
                            <select name="bulan" required>
                                <option value="Januari">Januari</option>
                                <option value="Februari">Februari</option>
                                <option value="Maret">Maret</option>
                                <option value="April">April</option>
                                <option value="Mei">Mei</option>
                                <option value="Juni">Juni</option>
                                <option value="Juli">Juli</option>
                                <option value="Agustus">Agustus</option>
                                <option value="September">September</option>
                                <option value="Oktober">Oktober</option>
                                <option value="November">November</option>
                                <option value="Desember">Desember</option>
                            </select>
                            <select name="tahun" required>
                                <% for (int i = 1980; i <= 2025; i++) { %>
                                    <option value="<%= i %>"><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Tempat Lahir:</td>
                        <td><input type="text" name="tempat_lahir" required></td>
                    </tr>
                    <tr>
                        <td>Jurusan:</td>
                        <td>
                            <select name="jurusan" required>
                                <option value="Teknik Informatika">Teknik Informatika</option>
                                <option value="Sistem Informasi">Sistem Informasi</option>
                                <option value="Teknik Elektro">Teknik Elektro</option>
                                <option value="Teknik Mesin">Teknik Mesin</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Tahun Masuk:</td>
                        <td>
                            <select name="tahun_masuk" required>
                                <% for (int i = 2000; i <= 2025; i++) { %>
                                    <option value="<%= i %>"><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" value="Submit">
                        </td>
                    </tr>
                </table>
            </form>
        </center>
    </body>
</html>
