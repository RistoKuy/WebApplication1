<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>Login | Aplikasi JSP</title>
    <!-- Panggil Bootstrap lokal -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --dark-bg: #121212;
            --dark-card: #1e1e1e;
            --dark-light: #2d2d2d;
            --accent-purple: #bb86fc;
            --accent-blue: #03dac6;
            --accent-pink: #cf6679;
            --text-primary: #e1e1e1;
            --text-secondary: #b0b0b0;
        }
        
        /* Hero background and overlay */
        .hero-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://images.unsplash.com/photo-1745750747228-d7ae37cba3a5?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: -10;
            filter: brightness(0.6);
        }
        
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(18, 18, 18, 0.7), rgba(32, 10, 64, 0.8));
            z-index: -5;
        }
        
        body {
            background-color: transparent;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .signup-container {
            background: rgba(30, 30, 30, 0.7);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .signup-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(187, 134, 252, 0.2);
            border-color: var(--accent-purple);
        }
        
        .form-section {
            width: 100%;
        }
        
        h1 {
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 2.5rem;
            color: var(--accent-purple);
            text-shadow: 0 0 5px rgba(187, 134, 252, 0.5);
        }
        
        .form-control {
            background-color: rgba(45, 45, 45, 0.7);
            color: var(--text-primary);
            border: 1px solid rgba(68, 68, 68, 0.5);
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
            backdrop-filter: blur(5px);
        }
        
        .form-control:focus {
            background-color: rgba(51, 51, 51, 0.8);
            border-color: var(--accent-purple);
            box-shadow: 0 0 0 0.25rem rgba(187, 134, 252, 0.25);
            outline: none;
        }
        
        .btn-register {
            background: linear-gradient(45deg, var(--accent-purple), #9a67ea);
            color: #121212;
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-register:hover {
            background: linear-gradient(45deg, #9a67ea, var(--accent-purple));
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
        }
        
        .register-link {
            margin-top: 15px;
            text-align: center;
            display: block;
            color: var(--accent-purple);
            text-decoration: none;
        }
        
        .register-link:hover {
            text-decoration: underline;
        }
        
        .back-button {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background-color: transparent;
            color: var(--accent-purple);
            border: 1px solid var(--accent-purple);
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
            background-color: var(--accent-purple);
            color: #121212;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(187, 134, 252, 0.3);
            opacity: 1;
        }
        
        @media (max-width: 768px) {
            .signup-container {
                padding: 30px;
            }
        }
    </style>
</head>
<body>
    <!-- Background image and overlay -->
    <div class="hero-background"></div>
    <div class="overlay"></div>
    
    <div class="signup-container">
        <a href="index.jsp" class="back-button" title="Back to Home">
            <i class="bi bi-arrow-right"></i>
        </a>
        <div class="form-section">
            <h1>Login</h1>
            
            <form action="login_output.jsp" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="isAdmin" name="isAdmin" value="1">
                        <label class="form-check-label" for="isAdmin">Login as Admin</label>
                    </div>
                </div>
                <div class="mt-4">
                    <button type="submit" class="btn-register">Login</button>
                </div>
                <a href="register.jsp" class="register-link">No account? Register</a>
            </form>
        </div>
    </div>
    
    <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>