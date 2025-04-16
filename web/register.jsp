<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Form Registrasi</title>
</head>
<body>
    <h1>Form Registrasi</h1>
    
    <form action="register_output.jsp" method="post">
        <div>
            <label for="nama">Nama:</label><br>
            <input type="text" id="nama" name="nama" required>
        </div>
        <div style="margin-top: 10px;">
            <label for="email">Email:</label><br>
            <input type="email" id="email" name="email" required>
        </div>
        <div style="margin-top: 10px;">
            <label for="password">Password:</label><br>
            <input type="password" id="password" name="password" required>
        </div>
        <div style="margin-top: 15px;">
            <button type="submit">Daftar</button>
        </div>
    </form>
</body>
</html>
