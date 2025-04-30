<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Register | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #121212; /* Warna latar belakang gelap */
            color: #e1e1e1; /* Warna teks terang */
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .signup-container {
            background: #1e1e1e; /* Warna latar belakang container gelap */
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.5);
            padding: 40px;
            max-width: 1000px;
            width: 100%;
            display: flex;
            overflow: hidden;
            position: relative;
        }
        .form-section {
            flex: 1;
            padding-right: 20px;
        }
        .image-section {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .image-section img {
            max-width: 100%;
            height: auto;
            filter: brightness(0.8); /* Mengurangi kecerahan gambar */
        }
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 2.5rem;
        }
        .form-control {
            background-color: #2d2d2d; /* Warna latar belakang input */
            color: #e1e1e1; /* Warna teks input */
            border: 1px solid #444; /* Warna border input */
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        .form-control:focus {
            background-color: #333; /* Warna latar belakang input saat fokus */
            border-color: #bb86fc; /* Warna border saat fokus */
            outline: none;
        }
        .btn-register {
            background-color: #bb86fc; /* Warna tombol */
            color: #121212; /* Warna teks tombol */
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-register:hover {
            background-color: #9a67ea; /* Warna tombol saat hover */
        }
        .login-link {
            margin-top: 15px;
            text-align: center;
            display: block;
            color: #bb86fc; /* Warna link */
            text-decoration: none;
        }
        .login-link:hover {
            text-decoration: underline;
        }
        .back-button {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background-color: transparent;
            color: #bb86fc;
            border: 1px solid #bb86fc;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0.7;
        }
        .back-button:hover {
            background-color: #bb86fc;
            color: #121212;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
            opacity: 1;
        }
        @media (max-width: 768px) {
            .signup-container {
                flex-direction: column;
            }
            .form-section {
                padding-right: 0;
                padding-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <a href="index.jsp" class="back-button" title="Back to Home">
            <i class="bi bi-arrow-right"></i>
        </a>
        <div class="form-section">
            <h1>Sign up</h1>
            
            <form action="register_output.jsp" method="post">
                <div class="mb-3">
                    <label for="nama" class="form-label">Your Name</label>
                    <input type="text" class="form-control" id="nama" name="nama" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="mt-4">
                    <button type="submit" class="btn-register">Register</button>
                </div>
                <a href="login.jsp" class="login-link">Already have an account? Log in</a>
            </form>
        </div>
        <div class="image-section">
            <img src="https://images.unsplash.com/photo-1745750747228-d7ae37cba3a5?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Registration illustration">
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
