<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Registrasi | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .signup-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 1000px;
            width: 100%;
            display: flex;
            overflow: hidden;
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
        }
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 2.5rem;
        }
        .form-control {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        .btn-register {
            background-color: #0d6efd;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-register:hover {
            background-color: #0b5ed7;
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
            </form>
        </div>
        <div class="image-section">
            <!-- You can replace this with an actual image path if you have one -->
            <img src="https://source.unsplash.com/random/600x600/?illustration" alt="Registration illustration">
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
