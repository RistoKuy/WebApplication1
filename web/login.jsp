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

        .btn-google {
            background-color: #ffffff;
            color: #333333;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 12px 30px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            margin-top: 15px;
        }

        .btn-google:hover {
            background-color: #f5f5f5;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .google-icon {
            width: 20px;
            height: 20px;
        }

        .login-divider {
            text-align: center;
            margin: 20px 0;
            position: relative;
            color: var(--text-secondary);
        }

        .login-divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: rgba(255, 255, 255, 0.2);
        }

        .login-divider span {
            background: rgba(30, 30, 30, 0.7);
            padding: 0 15px;
            position: relative;
            z-index: 1;
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
            
            <form id="loginForm" action="login_output.jsp" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="isAdmin" name="isAdmin" value="1">
                        <label class="form-check-label" for="isAdmin">Login as Admin</label>
                    </div>
                </div>                <div class="mt-4">
                    <button type="submit" class="btn-register">Login</button>
                </div>
                  <!-- Google Login Button (only for users) -->
                <div id="googleLoginSection" class="mt-3">
                    <div class="login-divider">
                        <span>or</span>
                    </div>
                    <button type="button" id="googleLoginBtn" class="btn-google" disabled>
                        <div class="spinner-border spinner-border-sm me-2" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        Loading Google...
                    </button>
                </div>
                
                <a href="register.jsp" class="register-link">No account? Register</a>
            </form>
        </div>
    </div>
      <!-- Panggil Bootstrap JS lokal -->
    <script src="js/bootstrap.bundle.min.js"></script>
    
    <!-- Include Firebase Configuration -->
    <%@ include file="firebase_config.jsp" %>    <script type="module">      // Wait for Firebase to be ready before setting up event listeners
      const setupEventListeners = () => {
        console.log('Setting up event listeners...');
        
        // Enable Google login button and set proper content
        const googleBtn = document.getElementById('googleLoginBtn');
        googleBtn.disabled = false;
        googleBtn.innerHTML = `
          <svg class="google-icon" viewBox="0 0 24 24">
            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
          Continue with Google
        `;
        
        console.log('Google login button enabled');
        
        // Check if Firebase is properly initialized
        if (!window.FirebaseUtils) {
          console.error('FirebaseUtils not available');
          googleBtn.disabled = true;
          googleBtn.innerHTML = 'Firebase Error';
          return;
        }
        
        if (!window.firebaseAuth) {
          console.error('Firebase Auth not available');
          googleBtn.disabled = true;
          googleBtn.innerHTML = 'Auth Error';
          return;
        }
        
        console.log('Firebase services are available');
        
        // Handle admin toggle - show/hide Google login section
        document.getElementById('isAdmin').addEventListener('change', function() {
          const googleSection = document.getElementById('googleLoginSection');
          if (this.checked) {
            googleSection.style.display = 'none';
          } else {
            googleSection.style.display = 'block';
          }
        });

        // Handle regular form submission
        document.getElementById('loginForm').addEventListener('submit', async function(e) {
          const isAdmin = document.getElementById('isAdmin').checked;
          if (isAdmin) {
            // Admin login: submit to server (local DB)
            return;
          }
          
          // User login: use Firebase
          e.preventDefault();
          const email = document.getElementById('email').value;
          const password = document.getElementById('password').value;
          
          if (!email || !password) {
            alert('Please enter both email and password');
            return;
          }
          
          try {
            const result = await window.FirebaseUtils.login(email, password);
            if (result.success) {
              // Show success message before redirect
              const formSection = document.querySelector('.form-section');
              const successDiv = document.createElement('div');
              successDiv.className = 'alert alert-success mt-3';
              successDiv.innerHTML = '<i class="bi bi-check-circle-fill me-2"></i>Login successful! Redirecting...';
              formSection.appendChild(successDiv);
              setTimeout(() => {
                window.location.href = 'main.jsp';
              }, 1200);
            } else {
              alert('Firebase login failed: ' + result.error);
            }
          } catch (error) {
            alert('Login error: ' + error.message);
          }
        });        // Handle Google login
        document.getElementById('googleLoginBtn').addEventListener('click', async function() {
          // Disable button to prevent multiple clicks
          const btn = this;
          btn.disabled = true;
          btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Signing in...';
            // Set a timeout to re-enable button if it takes too long
          const timeoutId = setTimeout(() => {
            console.warn('Google login timed out after 30 seconds');
            btn.disabled = false;
            btn.innerHTML = `
              <svg class="google-icon" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              Try Again
            `;
            alert('Google login timed out. Please try again or check if popups are blocked.');
          }, 30000); // 30 second timeout
          
          console.log('Starting Google login process...');
          
          try {
            const result = await window.FirebaseUtils.loginWithGoogle();
            clearTimeout(timeoutId); // Clear timeout if successful
            
            if (result.success) {
              if (result.redirect) {
                // Redirect method was used, page will reload
                return;
              }
              
              // Show success message before redirect
              const formSection = document.querySelector('.form-section');
              const successDiv = document.createElement('div');
              successDiv.className = 'alert alert-success mt-3';
              successDiv.innerHTML = '<i class="bi bi-check-circle-fill me-2"></i>Google login successful! Redirecting...';
              formSection.appendChild(successDiv);
              setTimeout(() => {
                window.location.href = 'main.jsp';
              }, 1200);
            } else {
              clearTimeout(timeoutId);
              alert('Google login failed: ' + result.error);
              // Re-enable button
              btn.disabled = false;
              btn.innerHTML = `
                <svg class="google-icon" viewBox="0 0 24 24">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                Continue with Google
              `;
            }
          } catch (error) {
            clearTimeout(timeoutId);
            console.error('Google login error:', error);
            alert('Google login error: ' + error.message);
            // Re-enable button
            btn.disabled = false;
            btn.innerHTML = `
              <svg class="google-icon" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              Continue with Google
            `;
          }
        });
      };

      // Wait for Firebase to be ready
      if (window.FirebaseUtils) {
        setupEventListeners();
      } else {
        window.addEventListener('firebaseReady', setupEventListeners);
      }
    </script>
</body>
</html>